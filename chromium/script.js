document.addEventListener('DOMContentLoaded', () => {
    // For shortcuts that go directly to a site
    const siteShortcuts = {
        '@mail': 'https://mail.proton.me/u/0/inbox',
        '@bril': 'https://brilliant.org',
        '@dis': 'https://discord.com/app',
        '@ai': 'http://localhost:8080' // Added the new ai shortcut
    };
    // For shortcuts that act as search operators
    // 'search': the operator to add to the query
    // 'url': where to go if you only type the shortcut key (e.g., "@arch")
    const searchShortcuts = {
        '@arch': {
            search: 'site:wiki.archlinux.org',
            url: 'https://wiki.archlinux.org/'
        },
        '@gem': {
            search: 'site:gemini.google.com',
            url: 'https://gemini.google.com/'
        },
        '@red': {
            search: 'site:reddit.com',
            url: 'https://www.reddit.com/'
        },
        '@unix': {
            search: 'site:reddit.com/r/unixporn',
            url: 'https://www.reddit.com/r/unixporn/'
        },
        '@git': {
            search: 'site:github.com',
            url: 'https://github.com/' // The base URL for path expansion
        },
        '@yt': {
            search: 'site:youtube.com',
            url: 'https://youtube.com/'
        },
        '@ytm': {
            search: 'site:music.youtube.com',
            url: 'https://music.youtube.com/'
        },
        '@hypr': {
            search: 'site:hypr.land',
            url: 'https://hypr.land'
        },
        '@mdn': {
            search: 'site:developer.mozilla.org',
            url: 'https://developer.mozilla.org'
        },
    };
    const searchForm = document.getElementById('search-form');
    const searchInput = searchForm.querySelector('input[name="q"]');
    const shortcutsContainer = document.getElementById('shortcuts-container');
    searchForm.addEventListener('submit', (event) => {
        const query = searchInput.value.trim();
        // A. Check for the @links command (no changes here)
        if (query === '@links') {
            event.preventDefault();
            if (shortcutsContainer.style.display === 'block') {
                shortcutsContainer.style.display = 'none';
                shortcutsContainer.innerHTML = '';
                searchInput.value = '';
                return;
            }
            const allShortcuts = {...siteShortcuts, ...searchShortcuts};
            shortcutsContainer.innerHTML = '';
            const list = document.createElement('ul');
            const sortedKeys = Object.keys(allShortcuts).sort();
            for (const key of sortedKeys) {
                const listItem = document.createElement('li');
                const url = typeof allShortcuts[key] === 'string' ? allShortcuts[key] : allShortcuts[key].url;
                const cleanUrl = url.replace(/^(https?:\/\/)?(www\.)?/, '').replace(/\/$/, '');
                listItem.innerHTML = `<span class="shortcut-key">${key}</span> → ${cleanUrl}`;
                list.appendChild(listItem);
            }
            shortcutsContainer.appendChild(list);
            shortcutsContainer.style.display = 'block';
            searchInput.value = '';
            return;
        }
        shortcutsContainer.style.display = 'none';
        // B. Check for direct site shortcuts (no changes here)
        if (siteShortcuts[query]) {
            event.preventDefault();
            window.open(siteShortcuts[query], '_blank');
            searchInput.value = '';
            return;
        }
        // C. REVISED LOGIC for search and path-based shortcuts
        for (const key in searchShortcuts) {
            if (query.startsWith(key)) {
                event.preventDefault();
                const shortcutData = searchShortcuts[key];
                const remainder = query.substring(key.length);
                // Case 1: Path expansion (e.g., "@git/user/repo")
                if (remainder.startsWith('/')) {
                    // Combine base URL with the new path.
                    // .replace(/\/$/, '') on the base URL prevents double slashes (e.g., "site.com//path")
                    const finalUrl = shortcutData.url.replace(/\/$/, '') + remainder;
                    window.open(finalUrl, '_blank');
                }
                // Case 2: Search query (e.g., "@git my project")
                else if (remainder.startsWith(' ') && remainder.trim().length > 0) {
                    const searchTerm = remainder.trim();
                    const finalQuery = `${searchTerm} ${shortcutData.search}`;
                    const searchUrl = `https://www.google.com/search?q=${encodeURIComponent(finalQuery)}`;
                    window.open(searchUrl, '_blank');
                }
                // Case 3: Just the shortcut key (e.g., "@git")
                else if (remainder.length === 0) {
                    window.open(shortcutData.url, '_blank');
                }
                // If it's none of the above (e.g. "@gitfoo"), we let it fall through
                else {
                    continue; // continue to next key in case of partial match like "@g" vs "@git"
                }
                searchInput.value = '';
                return; // Found and handled a shortcut, so we're done.
            }
        }
        // D. Check for a valid URL (no changes here)
        const urlPattern = /^(https?:\/\/)?([\w-]+\.)+[\w-]+(\/[\w-./?%&=]*)?$/i;
        if (urlPattern.test(query)) {
            event.preventDefault();
            let url = query;
            if (!/^https?:\/\/$/.test(url)) {
                url = 'https://' + url;
            }
            window.open(url, '_blank');
            searchInput.value = '';
            return;
        }
        // E. Default Google Search (no changes here)
        setTimeout(() => { searchInput.value = ''; }, 100);
    });
});
