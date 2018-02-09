export default class Article {
  constructor(opts) {
    this.title = opts.title;
    this.body = opts.body;
    this.createdAt = opts.created_at; // TODO: js parse date
    this.updatedAt = opts.updated_at;
  }
}
