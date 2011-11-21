From: NeilBrown <neilb@suse.de>
Subject: Re: raid1d crash at boot
Date: Mon, 21 Nov 2011 12:37:29 +1100
Message-ID: <20111121123729.47c72c3b@notabene.brown>
References: <20111119134139.GA30570@rere.qmqm.pl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/z+bvV5j_g4l2krbjQwvQwZP"; protocol="application/pgp-signature"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45528 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754095Ab1KUBhm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Nov 2011 20:37:42 -0500
In-Reply-To: <20111119134139.GA30570@rere.qmqm.pl>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?iso-8859-2?B?TWljaGGzIE1pcm9zs2F3?= <mirq-linux@rere.qmqm.pl>
Cc: linux-raid@vger.kernel.org, linux-scsi@vger.kernel.org

--Sig_/z+bvV5j_g4l2krbjQwvQwZP
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: quoted-printable


Thank for the report.
However as this crash is clearly in the SCSI layer it makes sense to report=
ed
it to linux-scsi - so I have cc:ed this reply there.

NeilBrown


On Sat, 19 Nov 2011 14:41:39 +0100 Micha=B3 Miros=B3aw <mirq-linux@rere.qmq=
m.pl>
wrote:

> I get following BUG_ON tripped while booting, before rootfs is mounted by
> Debian's initrd. This started to happen for kernels since sometime
> during 3.1-rcX.
>=20
> [    6.246170] ------------[ cut here ]------------
> [    6.246246] kernel BUG at /mnt/src-tmp/jaja/git/qmqm/drivers/scsi/scsi=
_lib.c:1153!
> [    6.246347] invalid opcode: 0000 [#1] PREEMPT SMP
> [    6.246558] CPU 5
> [    6.246614] Modules linked in: usb_storage uas firewire_ohci firewire_=
core crc_itu_t xhci_hcd [last unloaded: scsi_wait_scan]
> [    6.247131]
> [    6.247194] Pid: 288, comm: md1_raid1 Not tainted 3.2.0-rc2mq+ #5 Syst=
em manufacturer System Product Name/P8Z68-V PRO
> [    6.247422] RIP: 0010:[<ffffffff812443a1>]  [<ffffffff812443a1>] scsi_=
setup_fs_cmnd+0x45/0x83
> [    6.247563] RSP: 0018:ffff8804140d1bd0  EFLAGS: 00010046
> [    6.247634] RAX: 0000000000000000 RBX: ffff88041d463800 RCX: 00000000f=
fffffff
> [    6.247710] RDX: 00000000ffffffff RSI: ffff8804142fd600 RDI: ffff88041=
d463800
> [    6.247785] RBP: ffff8804142fd600 R08: 00000000ffffffff R09: 000000000=
0017a00
> [    6.247861] R10: ffff88041d464000 R11: ffff88041d464000 R12: 000000000=
0000800
> [    6.247936] R13: 0000000000000001 R14: ffff88041d463800 R15: 000000000=
0000000
> [    6.248013] FS:  0000000000000000(0000) GS:ffff88042fb40000(0000) knlG=
S:0000000000000000
> [    6.248104] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [    6.248176] CR2: 000000000042b200 CR3: 0000000001605000 CR4: 000000000=
00406e0
> [    6.248252] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 000000000=
0000000
> [    6.248328] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 000000000=
0000400
> [    6.248404] Process md1_raid1 (pid: 288, threadinfo ffff8804140d0000, =
task ffff88041539a4c0)
> [    6.248495] Stack:
> [    6.248557]  0000000000000000 ffff8804142fd600 ffff8804142fd600 ffffff=
ff8124a9be
> [    6.248819]  ffff8804142fe3a0 ffff8804142fd600 ffff88041d463848 ffffff=
ff811a5d67
> [    6.249084]  ffff8804142fe3a0 ffff880415452400 ffff8804156f0000 000000=
00fffffa2b
> [    6.249346] Call Trace:
> [    6.249414]  [<ffffffff8124a9be>] ? sd_prep_fn+0x2cd/0xb72
> [    6.249490]  [<ffffffff811a5d67>] ? cfq_dispatch_requests+0x6f2/0x82c
> [    6.249567]  [<ffffffff8119a168>] ? blk_peek_request+0xc8/0x1bf
> [    6.249638]  [<ffffffff81243d83>] ? scsi_request_fn+0x64/0x406
> [    6.249708]  [<ffffffff8119a526>] ? blk_flush_plug_list+0x186/0x1b7
> [    6.249780]  [<ffffffff8119a562>] ? blk_finish_plug+0xb/0x2a
> [    6.249849]  [<ffffffff812a400f>] ? raid1d+0x91/0xb22
> [    6.249919]  [<ffffffff81031729>] ? get_parent_ip+0x9/0x1b
> [    6.249990]  [<ffffffff813a5c9e>] ? sub_preempt_count+0x83/0x94
> [    6.250060]  [<ffffffff813a202a>] ? schedule+0x73f/0x772
> [    6.250129]  [<ffffffff813a5d49>] ? add_preempt_count+0x9a/0x9c
> [    6.250199]  [<ffffffff813a330b>] ? _raw_spin_lock_irqsave+0x13/0x31
> [    6.250271]  [<ffffffff812a9bb4>] ? md_thread+0xfe/0x11c
> [    6.250340]  [<ffffffff8104f6c6>] ? add_wait_queue+0x3c/0x3c
> [    6.250410]  [<ffffffff812a9ab6>] ? signal_pending+0x17/0x17
> [    6.250479]  [<ffffffff8104f045>] ? kthread+0x76/0x7e
> [    6.250548]  [<ffffffff813a8c34>] ? kernel_thread_helper+0x4/0x10
> [    6.250618]  [<ffffffff8104efcf>] ? kthread_worker_fn+0x139/0x139
> [    6.250688]  [<ffffffff813a8c30>] ? gs_change+0xb/0xb
> [    6.250754] Code: 85 c0 74 1d 48 8b 00 48 85 c0 74 15 48 8b 40 50 48 8=
5 c0 74 0c 48 89 ee 48 89 df ff d0 85 c0 75 44 66 83 bd d0 00 00 00 00 75 0=
2 <0f> 0b 48 89 ee 48 89 df e8 b6 e9 ff ff 48 85 c0 48 89 c2 74 20
> [    6.253544] RIP  [<ffffffff812443a1>] scsi_setup_fs_cmnd+0x45/0x83
> [    6.253658]  RSP <ffff8804140d1bd0>
> [    6.253722] ---[ end trace 533b0b5008dd7cee ]---
> [    6.253788] note: md1_raid1[288] exited with preempt_count 1
>=20
> I'm attaching dmesg log I could catch with netcosole (there's some part m=
issing).
>=20
> Best Regards,
> Micha=B3 Miros=B3aw


--Sig_/z+bvV5j_g4l2krbjQwvQwZP
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTsmrWTnsnt1WYoG5AQJKRw/+KOjSvgLrMgb5CwZlJp1UisB0UXNvT8HB
DoZsVPM7OOPig47rnu/3G2cV/j02SE0fsqx89mtLKPD/O85EMZb4lpnFdHmCY72c
6g0ZDZArwJ6RVrUqDXzVaBTmcSeI25VCxYXpKJTuxo5f4hh6iLhV0ID3cRo+Vqqt
MLo1DWpcCa9LbCpJ5+05Oqu2TEjvCRI4r+H9fDJdPRSr9UoxkDkJbniBliMG1tYa
kC38EuuiM4wmPFYGMqeomcxvchsA0+60ImXTGpl79pv2r5ZdlzSvzQsTpOuZPEHE
IZ5WP9+bj07Ipg1X1rf1IdN3W8FM6V7cDKB4B+VmusbyCx8QYBhjUBvwVNsHciMc
9nZqq38h+TJVTjkCJxpeMtomiYddP9e3g6pCRl6vUzV/H3qQWCVr+xWOKZ31932y
JEy3rkYel7VSp5ikdaFCOn1M1Hf8o7g4gcNmkKjcp+MzHTDQU3Kua6TK7/6yXsVz
dHThElK85ks3EXv51uJOaxnk3Cke1qeiIzo6rCADCWaEIjZ4kF9efUcUiUXcG8a6
8A/5Z3wB9JFu/8xxJeZncJRPWxSI6WQOyXHtL++6gjy3t95k+FQcxC/Z8HuN1JH7
UGsnOkvnqc3Wr3vBxFJ0VAvzVrZOxbRF3ili8Rba+QFeRAk6mLoHgiLxtr9zTDZ3
Xknrs8jb6B0=
=U81Z
-----END PGP SIGNATURE-----

--Sig_/z+bvV5j_g4l2krbjQwvQwZP--
