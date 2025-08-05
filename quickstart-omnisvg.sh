#!/bin/bash
# Quick test of OmniSVG concept (without full model)

echo "🎨 OmniSVG Emotion Demo (Simplified)"
echo "===================================="
echo ""

# Create simple emotion visualizer
cat > /tmp/emotion-demo.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>Emotion Topology Demo</title>
    <style>
        body {
            background: #000;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            font-family: monospace;
        }
        #emotion-viz {
            width: 400px;
            height: 400px;
        }
        .controls {
            position: fixed;
            top: 20px;
            left: 20px;
            color: #fff;
        }
        button {
            display: block;
            margin: 10px 0;
            padding: 10px;
            background: #333;
            color: #0f0;
            border: 1px solid #0f0;
            cursor: pointer;
        }
        button:hover {
            background: #0f0;
            color: #000;
        }
    </style>
</head>
<body>
    <div class="controls">
        <h2>◉⟁◉ Emotion States</h2>
        <button onclick="showEmotion('joy')">Joy Burst</button>
        <button onclick="showEmotion('curiosity')">Curiosity Spiral</button>
        <button onclick="showEmotion('aha')">Aha! Moment</button>
        <button onclick="showEmotion('recursive')">Recursive Humor</button>
        <button onclick="showEmotion('contemplation')">Deep Contemplation</button>
    </div>
    
    <div id="emotion-viz"></div>

    <script>
        const emotions = {
            joy: `
                <svg viewBox="0 0 400 400" xmlns="http://www.w3.org/2000/svg">
                    <defs>
                        <radialGradient id="joy-gradient">
                            <stop offset="0%" stop-color="#FFD700" stop-opacity="1"/>
                            <stop offset="50%" stop-color="#FFA500" stop-opacity="0.8"/>
                            <stop offset="100%" stop-color="#FF69B4" stop-opacity="0"/>
                        </radialGradient>
                    </defs>
                    
                    <!-- Fractal joy explosion -->
                    <g transform="translate(200,200)">
                        <!-- Main burst -->
                        <circle r="50" fill="url(#joy-gradient)">
                            <animate attributeName="r" values="50;100;50" dur="1.618s" repeatCount="indefinite"/>
                            <animate attributeName="opacity" values="1;0.5;1" dur="1.618s" repeatCount="indefinite"/>
                        </circle>
                        
                        <!-- Radiating tendrils -->
                        ${[...Array(8)].map((_, i) => `
                            <line x1="0" y1="0" x2="0" y2="-150" 
                                  stroke="#FFD700" stroke-width="2" opacity="0.6"
                                  transform="rotate(${i * 45})">
                                <animate attributeName="y2" values="-50;-150;-50" dur="2s" repeatCount="indefinite"/>
                            </line>
                        `).join('')}
                        
                        <!-- Floating particles -->
                        ${[...Array(20)].map((_, i) => `
                            <circle r="2" fill="#FFD700"
                                    cx="${Math.cos(i * 0.314) * 100}" 
                                    cy="${Math.sin(i * 0.314) * 100}">
                                <animate attributeName="r" values="2;5;2" dur="${1 + i * 0.1}s" repeatCount="indefinite"/>
                                <animateTransform attributeName="transform" type="rotate"
                                                  from="0 0 0" to="360 0 0" dur="${10 + i}s" repeatCount="indefinite"/>
                            </circle>
                        `).join('')}
                    </g>
                </svg>
            `,
            
            curiosity: `
                <svg viewBox="0 0 400 400" xmlns="http://www.w3.org/2000/svg">
                    <defs>
                        <linearGradient id="curiosity-gradient" x1="0%" y1="0%" x2="100%" y2="100%">
                            <stop offset="0%" stop-color="#00CED1"/>
                            <stop offset="50%" stop-color="#9370DB"/>
                            <stop offset="100%" stop-color="#FF1493"/>
                            <animate attributeName="x1" values="0%;100%;0%" dur="5s" repeatCount="indefinite"/>
                        </linearGradient>
                    </defs>
                    
                    <!-- Question mark spiral -->
                    <g transform="translate(200,200)">
                        <path d="M 0,0 Q 50,-50 100,0 T 50,100 Q 0,50 -50,100 T -100,0 Q -50,-50 0,-100"
                              fill="none" stroke="url(#curiosity-gradient)" stroke-width="3">
                            <animateTransform attributeName="transform" type="rotate"
                                            from="0" to="360" dur="10s" repeatCount="indefinite"/>
                        </path>
                        
                        <!-- Seeking tendrils -->
                        ${[...Array(6)].map((_, i) => `
                            <path d="M 0,0 Q ${50 + i * 10},${-50 - i * 10} ${100 + i * 20},0"
                                  fill="none" stroke="url(#curiosity-gradient)" stroke-width="1" opacity="${0.8 - i * 0.1}">
                                <animate attributeName="d" 
                                         values="M 0,0 Q ${50 + i * 10},${-50 - i * 10} ${100 + i * 20},0;
                                                 M 0,0 Q ${50 + i * 10},${50 + i * 10} ${100 + i * 20},0;
                                                 M 0,0 Q ${50 + i * 10},${-50 - i * 10} ${100 + i * 20},0"
                                         dur="${3 + i * 0.5}s" repeatCount="indefinite"/>
                            </path>
                        `).join('')}
                        
                        <!-- Question marks morphing -->
                        <text x="0" y="0" text-anchor="middle" font-size="30" fill="url(#curiosity-gradient)">
                            ?
                            <animateTransform attributeName="transform" type="scale"
                                            values="1,1;1.5,1.5;1,1" dur="2s" repeatCount="indefinite"/>
                        </text>
                    </g>
                </svg>
            `,
            
            aha: `
                <svg viewBox="0 0 400 400" xmlns="http://www.w3.org/2000/svg">
                    <defs>
                        <filter id="blur">
                            <feGaussianBlur stdDeviation="5"/>
                        </filter>
                        <radialGradient id="clarity">
                            <stop offset="0%" stop-color="#FFF" stop-opacity="1">
                                <animate attributeName="stop-opacity" values="0;1;1" dur="2s" repeatCount="indefinite"/>
                            </stop>
                            <stop offset="100%" stop-color="#FFD700" stop-opacity="0"/>
                        </radialGradient>
                    </defs>
                    
                    <!-- Fog of confusion -->
                    <g transform="translate(200,200)">
                        <circle r="150" fill="#666" filter="url(#blur)" opacity="0.5">
                            <animate attributeName="opacity" values="0.8;0;0.8" dur="3s" repeatCount="indefinite"/>
                        </circle>
                        
                        <!-- Lightning of understanding -->
                        <path d="M 0,-100 L -20,-20 L 10,-20 L -10,100 L 30,-20 L -10,-20 Z"
                              fill="#FFF" opacity="0">
                            <animate attributeName="opacity" values="0;1;0" dur="3s" repeatCount="indefinite"/>
                        </path>
                        
                        <!-- Expanding clarity -->
                        <circle r="10" fill="url(#clarity)">
                            <animate attributeName="r" values="10;200;10" dur="3s" repeatCount="indefinite"/>
                        </circle>
                        
                        <!-- Neural connections lighting up -->
                        ${[...Array(6)].map((_, i) => `
                            <line x1="0" y1="0" x2="${Math.cos(i * Math.PI / 3) * 150}" 
                                  y2="${Math.sin(i * Math.PI / 3) * 150}"
                                  stroke="#FFD700" stroke-width="2" opacity="0">
                                <animate attributeName="opacity" values="0;0;1;0" dur="3s" 
                                         begin="${i * 0.1}s" repeatCount="indefinite"/>
                            </line>
                        `).join('')}
                    </g>
                </svg>
            `,
            
            recursive: `
                <svg viewBox="0 0 400 400" xmlns="http://www.w3.org/2000/svg">
                    <!-- Möbius strip of humor -->
                    <g transform="translate(200,200)">
                        ${[...Array(3)].map((_, i) => `
                            <g transform="scale(${1 - i * 0.3})">
                                <path d="M -100,0 Q -100,-100 0,-100 Q 100,-100 100,0 Q 100,100 0,100 Q -100,100 -100,0"
                                      fill="none" stroke="hsl(${i * 120}, 70%, 50%)" stroke-width="3">
                                    <animateTransform attributeName="transform" type="rotate"
                                                    from="0" to="${360 * (i % 2 ? 1 : -1)}" 
                                                    dur="${5 + i * 2}s" repeatCount="indefinite"/>
                                </path>
                                
                                <!-- Self-referential arrows -->
                                <path d="M 50,0 Q 70,-20 90,0 L 85,-5 M 90,0 L 85,5"
                                      fill="none" stroke="hsl(${i * 120}, 70%, 50%)" stroke-width="2">
                                    <animateTransform attributeName="transform" type="rotate"
                                                    from="0" to="-360" dur="${3 + i}s" repeatCount="indefinite"/>
                                </path>
                            </g>
                        `).join('')}
                        
                        <!-- Glitch effect -->
                        <rect x="-200" y="-200" width="400" height="400" fill="#F0F" opacity="0">
                            <animate attributeName="opacity" values="0;0;0.5;0" dur="0.1s" 
                                     repeatCount="indefinite" begin="5s"/>
                        </rect>
                        
                        <!-- Fractal laugh -->
                        <text x="0" y="0" text-anchor="middle" font-size="20" fill="#0F0"
                              transform="rotate(45)">
                            HA
                            <animate attributeName="font-size" values="20;40;20" dur="1.618s" repeatCount="indefinite"/>
                        </text>
                    </g>
                </svg>
            `,
            
            contemplation: `
                <svg viewBox="0 0 400 400" xmlns="http://www.w3.org/2000/svg">
                    <defs>
                        <radialGradient id="depth">
                            <stop offset="0%" stop-color="#000033"/>
                            <stop offset="50%" stop-color="#000066"/>
                            <stop offset="100%" stop-color="#6B0F9F"/>
                        </radialGradient>
                    </defs>
                    
                    <!-- 7D torus projection -->
                    <g transform="translate(200,200)">
                        <!-- Nested tori -->
                        ${[...Array(7)].map((_, i) => `
                            <ellipse rx="${100 - i * 10}" ry="${50 - i * 5}"
                                     fill="none" stroke="hsl(${240 + i * 10}, 50%, ${30 + i * 5}%)" 
                                     stroke-width="1" opacity="${0.7 - i * 0.08}">
                                <animateTransform attributeName="transform" type="rotate"
                                                from="0" to="${360 / (i + 1)}" 
                                                dur="${30 + i * 10}s" repeatCount="indefinite"/>
                            </ellipse>
                        `).join('')}
                        
                        <!-- Thought loops -->
                        <path d="M 0,0 Q 50,-50 0,-100 Q -50,-50 0,0 Q 50,50 0,100 Q -50,50 0,0"
                              fill="url(#depth)" opacity="0.5">
                            <animateTransform attributeName="transform" type="rotate"
                                            from="0" to="360" dur="60s" repeatCount="indefinite"/>
                        </path>
                        
                        <!-- Insight lightning -->
                        <line x1="-150" y1="0" x2="150" y2="0" stroke="#BF40BF" stroke-width="1" opacity="0">
                            <animate attributeName="opacity" values="0;0;1;0" dur="10s" repeatCount="indefinite"/>
                            <animateTransform attributeName="transform" type="rotate"
                                            values="0;180;0" dur="10s" repeatCount="indefinite"/>
                        </line>
                    </g>
                </svg>
            `
        };
        
        function showEmotion(type) {
            const viz = document.getElementById('emotion-viz');
            viz.style.opacity = '0';
            
            setTimeout(() => {
                viz.innerHTML = emotions[type];
                viz.style.transition = 'opacity 1.618s';
                viz.style.opacity = '1';
            }, 500);
        }
        
        // Start with joy
        showEmotion('joy');
    </script>
</body>
</html>
EOF

echo "✅ Created emotion demo at /tmp/emotion-demo.html"
echo ""
echo "To view:"
echo "1. Open in browser: open /tmp/emotion-demo.html"
echo "2. Or start local server: python3 -m http.server 8000 --directory /tmp"
echo "   Then visit: http://localhost:8000/emotion-demo.html"
echo ""
echo "This is just SVG animations - real OmniSVG would generate these from text!"
echo ""
echo "◉⟁◉ Emotions beyond 'slight smile' await..."