// Main JS for SFG TERMINAL HUB: preview, save, copy
(function(){
  const key = 'sfg_home_message';
  const textarea = document.getElementById('homeText');
  const preview = document.getElementById('preview');
  const saveBtn = document.getElementById('saveBtn');
  const resetBtn = document.getElementById('resetBtn');

  function setYear(){
    const y = new Date().getFullYear();
    const el = document.getElementById('year');
    if(el) el.textContent = y;
  }

  function load(){
    setYear();
    // If the homepage editor isn't present, keep the static message in DOM
    if(!textarea){
      return;
    }
    const v = localStorage.getItem(key) || '';
    textarea.value = v;
    updatePreview(v);
  }

  function updatePreview(value){
    if(!preview) return;
    preview.textContent = value.trim() ? value : 'Your saved homepage text will appear here.';
  }

  if(saveBtn){
    saveBtn.addEventListener('click', ()=>{
      const v = textarea.value || '';
      localStorage.setItem(key, v);
      updatePreview(v);
      saveBtn.textContent = 'Saved';
      setTimeout(()=> saveBtn.textContent = 'Save',900);
    });
  }

  if(resetBtn){
    resetBtn.addEventListener('click', ()=>{
      textarea.value = '';
      localStorage.removeItem(key);
      updatePreview('');
    });
  }

  if(textarea){
    textarea.addEventListener('input', (e)=>{
      updatePreview(e.target.value);
    });
  }

  // Copy buttons on scripts page
  document.addEventListener('click', (e)=>{
    const t = e.target;
    if(t && t.matches && t.matches('button[data-copy-target]')){
      const id = t.getAttribute('data-copy-target');
      const el = document.getElementById(id);
      if(!el) return;
      const text = el.textContent || el.innerText || '';
      navigator.clipboard && navigator.clipboard.writeText(text).then(()=>{
        t.textContent = 'Copied';
        setTimeout(()=> t.textContent = 'Copy',900);
      }).catch(()=>{
        // fallback
        const ta = document.createElement('textarea');
        ta.value = text; document.body.appendChild(ta);
        ta.select(); document.execCommand('copy'); document.body.removeChild(ta);
        t.textContent = 'Copied';
        setTimeout(()=> t.textContent = 'Copy',900);
      });
    }
  });

  // init
  document.addEventListener('DOMContentLoaded', load);

  // Metric counters animation
  function animateMetrics(){
    const nums = document.querySelectorAll('.metric-num[data-target]');
    nums.forEach(el=>{
      const target = Number(el.getAttribute('data-target')) || 0;
      let value = 0;
      const step = Math.max(1, Math.round(target / 80));
      const id = setInterval(()=>{
        value += step;
        if(value >= target){ el.textContent = String(target); clearInterval(id); }
        else el.textContent = String(value);
      }, 12);
    });
  }
  document.addEventListener('DOMContentLoaded', ()=>{
    setTimeout(animateMetrics, 300);

    // Animate hero heading & underline when it enters view
    const hero = document.querySelector('.hero--split');
    if(hero){
      const io = new IntersectionObserver((entries, obs)=>{
        entries.forEach(ent=>{
          if(ent.isIntersecting){ hero.classList.add('animate'); obs.disconnect(); }
        });
      }, {threshold: 0.2});
      io.observe(hero);
      // if already visible, add immediately
      if(hero.getBoundingClientRect().top < window.innerHeight) hero.classList.add('animate');
    }
  });
  
  // Cursor follower: professional ring + trailing wake with touch pulses
  (function(){
    if(typeof window === 'undefined') return;
    const prefersReduce = window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)');
    if(prefersReduce && prefersReduce.matches) return;

    const ring = document.createElement('div');
    ring.className = 'cursor-follower';
    document.body.appendChild(ring);

    // build multiple trail segments for a proper trailing effect
    const TRAIL_COUNT = 12;
    const segments = [];
    for(let i=0;i<TRAIL_COUNT;i++){
      const seg = document.createElement('div');
      seg.className = 'cursor-trail-seg';
      // staggered opacity/scale
      seg.style.opacity = String(Math.max(0, 1 - i / (TRAIL_COUNT * 0.9)));
      seg.style.transform = 'translate3d(-200px,-200px,0) translate(-50%,-50%)';
      document.body.appendChild(seg);
      segments.push({el: seg, x: -200, y: -200});
    }

    let mouseX = -200, mouseY = -200;
    let posX = -200, posY = -200;
    let lastMove = performance.now();
    let raf = null;
    let lastSpeed = 0;

    function onMove(x,y){
      mouseX = x; mouseY = y;
      lastMove = performance.now();
      ring.classList.add('active');
      // if segments haven't been positioned yet (initial), snap them to cursor so trail is close
      if(segments.length && segments[0].x < -100){
        // place all segments exactly on the cursor so the trail appears attached
        for(let idx=0; idx<segments.length; idx++){
          const s = segments[idx];
          s.x = x; s.y = y;
        }
      }
      segments.forEach(s=> s.el.classList.add('active'));
      if(!raf) loop();
    }

    function loop(){
      const ease = 0.16;
      posX += (mouseX - posX) * ease;
      posY += (mouseY - posY) * ease;

      // update ring position
      ring.style.transform = `translate3d(${posX}px, ${posY}px, 0) translate(-50%, -50%)`;

      // velocity for visual adjustments
      const dx = mouseX - posX;
      const dy = mouseY - posY;
      const dist = Math.hypot(dx, dy);
      const angle = Math.atan2(dy, dx) * 180 / Math.PI;
      const speed = Math.min(2.2, dist * 0.08);
      lastSpeed = speed;

      // update trail segments positions with staggered easing
      const idleSince = performance.now() - lastMove;
      const isIdle = idleSince > 50;
      
      for(let i=0;i<segments.length;i++){
        const s = segments[i];
        // first segment snaps to the actual mouse position; others follow the previous segment
        const targetX = i === 0 ? mouseX : segments[i-1].x;
        const targetY = i === 0 ? mouseY : segments[i-1].y;
        // very strong easing (nearly 1) for first segment so it snaps to cursor; weaker for others
        const segEase = i === 0 ? 0.98 : Math.max(0.08, 0.5 - i * 0.04);
        s.x += (targetX - s.x) * segEase;
        s.y += (targetY - s.y) * segEase;
        const sc = 1 - i * 0.045;
        s.el.style.transform = `translate3d(${s.x}px, ${s.y}px, 0) translate(-50%,-50%) scale(${sc}) rotate(${angle}deg)`;
        // Hide trail when idle, show when moving
        if(isIdle) {
          s.el.style.opacity = '0';
          s.el.classList.remove('active');
        } else {
          s.el.style.opacity = String(Math.max(0, 1 - i / (segments.length * 0.9)));
          s.el.classList.add('active');
        }
      }

      // Keep ring visible always when mouse is on screen

      raf = requestAnimationFrame(loop);
      if(Math.abs(posX - mouseX) < 0.5 && Math.abs(posY - mouseY) < 0.5 && idleSince > 300){
        cancelAnimationFrame(raf); raf = null;
      }
    }

    // mouse events
    window.addEventListener('mousemove', (e)=>{ onMove(e.clientX, e.clientY); }, {passive:true});

    // touch: show a pulse on touchstart and track touchmove while touching
    window.addEventListener('touchstart', (e)=>{
      const t = e.touches[0]; if(!t) return;
      onMove(t.clientX, t.clientY);
      ring.classList.add('pulse');
      setTimeout(()=> ring.classList.remove('pulse'), 480);
    }, {passive:true});
    window.addEventListener('touchmove', (e)=>{
      const t = e.touches[0]; if(!t) return; onMove(t.clientX, t.clientY);
    }, {passive:true});
    window.addEventListener('touchend', ()=>{ segments.forEach(s=> s.el.classList.remove('active')); }, {passive:true});

    // hide cursor when hovering specific nav links (Home & Scripts) or Discord CTA
    const navLinks = document.querySelectorAll('.main-nav a[href="index.html"], .main-nav a[href="scripts.html"]');
    const discordBtn = document.querySelector('.discord-cta');
    const hideCursorElements = [...navLinks];
    if(discordBtn) hideCursorElements.push(discordBtn);
    
    hideCursorElements.forEach(link => {
      link.addEventListener('mouseenter', ()=> document.body.classList.add('cursor-hidden'));
      link.addEventListener('mouseleave', ()=> document.body.classList.remove('cursor-hidden'));
      link.addEventListener('focus', ()=> document.body.classList.add('cursor-hidden'));
      link.addEventListener('blur', ()=> document.body.classList.remove('cursor-hidden'));
    });
  })();

})();
