# Deployment checklist

- [ ] Confirm every name, phone number, email, and address in the source PDF/SQL is synthetic or remove/anonymise it before making the repository public.
- [ ] Reconcile the 5-record SQL dump with the 11-record examples in the Data Book.
- [ ] Confirm the SQLite file was rebuilt from the approved source dump.
- [ ] Run the app locally and verify the pages and exports.
- [ ] Push the project to the GitHub repository.
- [ ] In Streamlit Community Cloud, select the GitHub repo, branch, and `streamlit_app.py`.
- [ ] Open the public URL in a private/incognito browser window to test anonymous access.
- [ ] Add a clear demo disclaimer to the deployed app profile/README.
- [ ] Do not enable record editing until a persistent database and authentication/permissions are implemented.
