# ChangeMe PWA

### Build Instructions

Search for "changeme":

```shell
grep -ir changeme
```

Replace all instances appropriately.

Prequisite dependencies:
  - [Yarn](https://yarnpkg.com/en/)
  - [Parcel](https://parceljs.org/)

Install the JS depedencies:

```shell
yarn install
```

When you need to generate GraphQL types, ensure the [API](https://github.com/changeme/api) is running on port 4000, and then run:

```shell
yarn run api
```

You are now ready to run the application:

```
yarn run parcel index.html
```

You're all setup! 🎉 
