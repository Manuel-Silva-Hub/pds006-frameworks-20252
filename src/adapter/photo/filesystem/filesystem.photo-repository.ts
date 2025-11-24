import { DeviceId } from "@/core/domain";
import { DevicePhotoRepository } from "@/core/repository";
import { Server } from "bun";
import { mkdirSync, existsSync } from "fs";

const PORT = Bun.env.PORT || 3000;

// Azure-friendly path
const BASE_PATH = "/home/site/wwwroot/public";

// Make sure folder exists
if (!existsSync(BASE_PATH)) {
  mkdirSync(BASE_PATH, { recursive: true });
}

const BASE_URL = `${Bun.env.PUBLIC_URL}/photo/`;

export class FileSystemPhotoRepository implements DevicePhotoRepository {
  public server: Server;

  constructor() {
    this.server = Bun.serve({
      port: PORT,
      routes: {
        "/photo/:filename": req =>
          new Response(Bun.file(`${BASE_PATH}/${req.params.filename}`))
      },
      error() {
        return new Response(null, { status: 404 });
      }
    });
  }

  async savePhoto(file: File, id: DeviceId): Promise<URL> {
    const extension = this.getFileExtension(file);
    if (!extension) return Promise.reject();

    const filename = `${id}.${extension}`;
    const path = `${BASE_PATH}/${filename}`;

    await Bun.write(path, file);

    return new URL(filename, BASE_URL);
  }

  getFileExtension(file: File): string | undefined {
    const parts = file.name.split(".");
    return parts.length > 1 ? parts.pop() : undefined;
  }
}
