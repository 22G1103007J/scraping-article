module.exports = {
    mode: "production",
    entry: "./src/index.js",
    output: {
        path: `${__dirname}/dist`,
        filename: "bandle.js"
    },

    module: {
        rules: [
            {
                test: /\.css$/,
                use: ["style-loader", "css-loader"],
            },
            {
                test: /\.js$/,
                use: {
                    loader: 'babel-loader',
                    options: {
                        presets: [
                            '@babel/preset-react'
                        ],
                    }
                },
            },
        ],
    }
}
