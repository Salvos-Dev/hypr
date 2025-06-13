document.addEventListener('DOMContentLoaded', () => {
    // --- 1. Define your shortcut types ---

    // For shortcuts that go directly to a site
    const siteShortcuts = {
        '@mail': 'https://mail.proton.me/u/0/inbox',
    };

    // For shortcuts that act as search operators
    // 'search': the operator to add to the query
    // 'url': where to go if you only type the shortcut key (e.g., "@arch")
    const searchShortcuts = {
        '@arch': {
            search: 'site:wiki.archlinux.org',
            url: 'https://wiki.archlinux.org/'
        },
        '@gemini': {
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
            url: 'https://github.com/'
        },
        '@yt': {
            search: 'site:youtube.com',
            url: 'https://youtube.com/'
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
        const queryParts = query.split(' ');
        const firstPart = queryParts[0];

        // --- 2. Implement the new logic flow ---

        // A. Check for the @links command
        if (query === '@links') {
            event.preventDefault();
            // Combine both shortcut types for display
            const allShortcuts = {...siteShortcuts, ...searchShortcuts};
            shortcutsContainer.innerHTML = '';
            const list = document.createElement('ul');
            for (const key in allShortcuts) {
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

        // B. Check for a Site Shortcut (exact match)
        if (siteShortcuts[query]) {
            event.preventDefault();
            window.open(siteShortcuts[query], '_blank');
            searchInput.value = '';
            return;
        }

        // C. Check for a Search Shortcut (starts with the key)
        if (searchShortcuts[firstPart]) {
            event.preventDefault();
            const shortcutData = searchShortcuts[firstPart];
            
            // If the user only typed the key (e.g., "@arch"), go to the main URL
            if (queryParts.length === 1) {
                window.open(shortcutData.url, '_blank');
            } else {
                // Otherwise, build a custom Google search
                const searchTerm = queryParts.slice(1).join(' ');
                const finalQuery = `${searchTerm} ${shortcutData.search}`;
                const searchUrl = `https://www.google.com/search?q=${encodeURIComponent(finalQuery)}`;
                window.open(searchUrl, '_blank');
            }
            searchInput.value = '';
            return;
        }

        // D. Check for a full URL
        const urlPattern = /^(https?:\/\/)?([\w-]+\.)+[\w-]+(\/[\w-./?%&=]*)?$/i;
        if (urlPattern.test(query)) {
            event.preventDefault();
            let url = query;
            if (!/^https?:\/\//i.test(url)) {
                url = 'https://' + url;
            }
            window.open(url, '_blank');
            searchInput.value = '';
            return;
        }

        // E. Default to a regular Google search
        setTimeout(() => { searchInput.value = ''; }, 100);
    });
});
