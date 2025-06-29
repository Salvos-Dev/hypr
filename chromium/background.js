chrome.runtime.onInstalled.addListener(function (details) {
  if (details.reason === "install") {
    // The URL to your startpage within the extension
    let startPageUrl = chrome.runtime.getURL("startpage.html");

    // Use the fetch API to check if the file actually exists
    fetch(startPageUrl)
      .then(response => {
        // If the response is ok (status 200-299), the file exists.
        if (response.ok) {
          console.log("startpage.html found. Opening in a new tab.");
          chrome.tabs.create({ url: "startpage.html" });
        } else {
          // The file exists but there might be a server-side issue (less likely for local files)
          throw new Error('File found but could not be loaded. Status: ' + response.status);
        }
      })
      .catch(error => {
        // This block will be hit if the file is not found (network error)
        console.error("Error: startpage.html not found! Please check the extension files.");
        console.error("Falling back to the default new tab page.");
        // Optional: You could open the default new tab page instead.
        // chrome.tabs.create({ url: "chrome://newtab" }); 
      });
  }
});
