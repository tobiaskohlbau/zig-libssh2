const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const lib = b.addStaticLibrary(.{
        .name = "ssh2",
        .target = target,
        .optimize = optimize,
    });
    lib.addIncludePath(.{ .path = "libssh2/include" });
    lib.addIncludePath(.{ .path = "config" });
    lib.addCSourceFiles(.{ .files = srcs, .flags = &.{} });
    lib.linkLibC();

    lib.defineCMacro("LIBSSH2_MBEDTLS", null);
    if (target.result.os.tag == .windows) {
        lib.defineCMacro("_CRT_SECURE_NO_DEPRECATE", "1");
        lib.defineCMacro("HAVE_LIBCRYPT32", null);
        lib.defineCMacro("HAVE_WINSOCK2_H", null);
        lib.defineCMacro("HAVE_IOCTLSOCKET", null);
        lib.defineCMacro("HAVE_SELECT", null);
        lib.defineCMacro("LIBSSH2_DH_GEX_NEW", "1");

        if (target.result.isGnu()) {
            lib.defineCMacro("HAVE_UNISTD_H", null);
            lib.defineCMacro("HAVE_INTTYPES_H", null);
            lib.defineCMacro("HAVE_SYS_TIME_H", null);
            lib.defineCMacro("HAVE_GETTIMEOFDAY", null);
        }
    } else {
        lib.defineCMacro("HAVE_UNISTD_H", null);
        lib.defineCMacro("HAVE_INTTYPES_H", null);
        lib.defineCMacro("HAVE_STDLIB_H", null);
        lib.defineCMacro("HAVE_SYS_SELECT_H", null);
        lib.defineCMacro("HAVE_SYS_UIO_H", null);
        lib.defineCMacro("HAVE_SYS_SOCKET_H", null);
        lib.defineCMacro("HAVE_SYS_IOCTL_H", null);
        lib.defineCMacro("HAVE_SYS_TIME_H", null);
        lib.defineCMacro("HAVE_SYS_UN_H", null);
        lib.defineCMacro("HAVE_LONGLONG", null);
        lib.defineCMacro("HAVE_GETTIMEOFDAY", null);
        lib.defineCMacro("HAVE_INET_ADDR", null);
        lib.defineCMacro("HAVE_POLL", null);
        lib.defineCMacro("HAVE_SELECT", null);
        lib.defineCMacro("HAVE_SOCKET", null);
        lib.defineCMacro("HAVE_STRTOLL", null);
        lib.defineCMacro("HAVE_SNPRINTF", null);
        lib.defineCMacro("HAVE_O_NONBLOCK", null);
    }

    const mbedtls = b.dependency("mbedtls", .{ .target = target, .optimize = optimize });
    lib.linkLibrary(mbedtls.artifact("mbedtls"));

    lib.installHeader(.{ .path = "libssh2/include/libssh2.h" }, "libssh2.h");

    b.installArtifact(lib);

    const test_step = b.step("test", "fake test step for now");
    _ = test_step;
}

const srcs = &.{
    "libssh2/src/channel.c",
    "libssh2/src/comp.c",
    "libssh2/src/crypt.c",
    "libssh2/src/hostkey.c",
    "libssh2/src/kex.c",
    "libssh2/src/mac.c",
    "libssh2/src/misc.c",
    "libssh2/src/packet.c",
    "libssh2/src/publickey.c",
    "libssh2/src/scp.c",
    "libssh2/src/session.c",
    "libssh2/src/sftp.c",
    "libssh2/src/userauth.c",
    "libssh2/src/transport.c",
    "libssh2/src/version.c",
    "libssh2/src/knownhost.c",
    "libssh2/src/agent.c",
    "libssh2/src/mbedtls.c",
    "libssh2/src/pem.c",
    "libssh2/src/keepalive.c",
    "libssh2/src/global.c",
    "libssh2/src/blowfish.c",
    "libssh2/src/bcrypt_pbkdf.c",
    "libssh2/src/agent_win.c",
};
