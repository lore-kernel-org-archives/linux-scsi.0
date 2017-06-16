From: Alice Ferrazzi <alicef@gentoo.org>
Subject: [RFC] ubsan: signed integer overflow in scsi_partsize
Date: Fri, 16 Jun 2017 22:29:32 +0900
Message-ID: <20170616132932.GG20222@alitoo>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="jt0yj30bxbg11sci"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


--jt0yj30bxbg11sci
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

A Gentoo user reported a USBAN signed integer overflow in scsicam.c
Shall we change something?

================================================================================
kernel: UBSAN: Undefined behaviour in drivers/scsi/scsicam.c:173:29
kernel: signed integer overflow:
kernel: 62015235 * 63 cannot be represented in type 'int'
kernel: CPU: 0 PID: 14131 Comm: fdisk Tainted: P           O
4.9.25-gentoo #4
...
kernel: d6629cec d1f444f2 00000007 d6629d1c 0000003f d6629cfc d1fc8ffe
d6629cfc
kernel: d3037320 d6629d80 d1fc934b d28b15c0 d6629d20 0000002a d6629d48
d3037320
kernel: 0000002a 00003202 31303236 35333235 ecd1f900 ecd1f9a8 d6629d5c
d189d121
kernel: Call Trace:
kernel: [<d1f444f2>] dump_stack+0x59/0x87
kernel: [<d1fc8ffe>] ubsan_epilogue+0xe/0x40
kernel: [<d1fc934b>] handle_overflow+0xbb/0xf0
kernel: [<d189d121>] ? do_read_cache_page+0x71/0x570
kernel: [<d19fd000>] ? blkdev_readpages+0x20/0x20
kernel: [<d189d646>] ? read_cache_page+0x26/0x50
kernel: [<d1fc93d2>] __ubsan_handle_mul_overflow+0x12/0x20
kernel: [<d224bbf7>] scsi_partsize+0x217/0x2e0
kernel: [<d224bd06>] scsicam_bios_param+0x46/0x380
kernel: [<d2299604>] sd_getgeo+0x174/0x2d0
kernel: [<d1f02c91>] blkdev_ioctl+0x251/0x12c0
kernel: [<d19fd31c>] block_ioctl+0x4c/0xb0
kernel: [<d19ab140>] do_vfs_ioctl+0xc0/0xdf0
kernel: [<d19c7e13>] ? mntput+0x23/0x60
kernel: [<d1987c99>] ? __fput+0x1e9/0x4e0
kernel: [<d1987fd8>] ? ____fput+0x8/0x10
kernel: [<d16d9520>] ? task_work_run+0x60/0xd0
kernel: [<d19abe9e>] SyS_ioctl+0x2e/0x60
kernel: [<d1602c0d>] do_fast_syscall_32+0x11d/0x550
kernel: [<d19abe70>] ? do_vfs_ioctl+0xdf0/0xdf0
kernel: [<d265940a>] sysenter_past_esp+0x47/0x75
kernel:
================================================================================

Thanks,
Alice

--jt0yj30bxbg11sci
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEELk4IVkYcBYUTNvSWViGmsoY4eBoFAllD3S8ACgkQViGmsoY4
eBphpBAApdHvrBg8ibwbLNX8NRO8D8Jxm7qB/DbJYEbxK7JLMMTT2cus9htvAcB8
82hNP1UYE36Z58B2ZYFPng+LvJbmbL6KHOZJOSA2VKyZANXfk0D/F3OjJOEyxx+H
sLZvne62UDBDKm+TE33IfqNMilyXLv5Xn/yH9psX8lKz6HFxpBI56ITeEzdSjQwB
B+jmZT8Crt1Tk22nBjMtPZiQ/oDwY51iAi7qC6VulsAkMrZ/d6gyYM0eNez/Tnrx
N8maQeOrT6B9H6CgzIcF5NVNsz0yrBhz3++OsLhRyfMuKIRCqc450Mr9s+Xu2Tqt
8kR3HyaAjgyofKu10c7yYjMvex1lTNsrNCg+bR6tpMEUPp9JbcQ1yEOrbWby+6Hv
6XNrPiMCsZwH8mRtBsAZF+54BpFz4SZK8bhuv587+gYEjcKVV/DtrN3UNB9ItDrZ
FCIgdh7ZgxltjUs7EE0NH74vezxH5TlWTIebBXqh4O0IhoaqPNBWPRdcucYEl8CI
4zSw8gkLDwG/2UVBqZdP7tOSiiIDYCfLpTrgTjpYy/+0KFSLY6OTZbv1+gPW/WaP
LwzU3fws4cqiAIzpn4eHRmVvCnKnq3snu8+cIXssEHz4Pky5QhnaekNdStCU59Ar
XZlS38v57v+cIhqQauFMjweytJ3bXiHqmo5KEJbEl3KB6OET7eo=
=h2ZE
-----END PGP SIGNATURE-----

--jt0yj30bxbg11sci--
