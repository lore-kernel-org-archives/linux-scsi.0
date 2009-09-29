From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: scsi tree boot filure
Date: Tue, 29 Sep 2009 11:27:04 +1000
Message-ID: <20090929112704.d1a022e1.sfr@canb.auug.org.au>
References: <20090927164314.9377c24c.sfr@canb.auug.org.au>
	<1254149694.4302.57.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__29_Sep_2009_11_27_04_+1000_kj21e/zFy650E1Ar"
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <1254149694.4302.57.camel@mulgrave.site>
Sender: linux-next-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, James Smart <James.Smart@Emulex.Com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

--Signature=_Tue__29_Sep_2009_11_27_04_+1000_kj21e/zFy650E1Ar
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi James,

On Mon, 28 Sep 2009 14:54:54 +0000 James Bottomley <James.Bottomley@suse.de=
> wrote:
>
> On Sun, 2009-09-27 at 16:43 +1000, Stephen Rothwell wrote:
> >=20
> > next-20090926 does not boot on some of my PowerPC partitions:
> >=20
> > calling  .ibmvscsi_module_init+0x0/0xb8 @ 1
> > ibmvscsi 30000028: SRP_VERSION: 16.a
> > scsi0 : IBM POWER Virtual SCSI Adapter 1.5.8
> > ibmvscsi 30000028: partner initialization complete
> > ibmvscsi 30000028: host srp version: 16.a, host partition 1-Didgo-VIOS =
(1), OS 3, max io 1048576
> > ibmvscsi 30000028: Client reserve enabled
> > ibmvscsi 30000028: sent SRP login
> > ibmvscsi 30000028: SRP_LOGIN succeeded
> > Unable to handle kernel paging request for data at address 0x00000058
> > Faulting instruction address: 0xc0000000003a6280
> > Oops: Kernel access of bad area, sig: 11 [#1]
> > SMP NR_CPUS=3D128 NUMA pSeries
> > Modules linked in:
> > NIP: c0000000003a6280 LR: c0000000003a63b4 CTR: 0000000000000000
> > REGS: c00000007c3f3020 TRAP: 0300   Not tainted  (2.6.31-autokern1)
> > MSR: 8000000000009032 <EE,ME,IR,DR>  CR: 24002042  XER: 00000001
> > DAR: 0000000000000058, DSISR: 0000000040000000
> > TASK =3D c00000007c3e8000[1] 'swapper' THREAD: c00000007c3f0000 CPU: 3
> > GPR00: 0000000000000000 c00000007c3f32a0 c000000000bc5390 c000000000a76=
420=20
> > GPR04: c000000000b97818 c0000000015abc70 0000000000000000 c00000007c81c=
918=20
> > GPR08: c00000007c81c888 0000000002000000 0000000000000002 c0000000014ec=
bcc=20
> > GPR12: 0000000024000042 c000000000c1ea80 0000000003500000 c00000000074a=
f10=20
> > GPR16: c000000000749588 0000000000000000 0000000000000000 0000000000000=
000=20
> > GPR20: c00000007c3f3600 c000000079074c00 c00000007c81c000 0000000002f1f=
8e0=20
> > GPR24: 0000000000000000 0000000000000000 0000000000000000 c000000079074=
c28=20
> > GPR28: c00000007c81c000 0000000000000000 c000000000b353f0 c000000000b97=
818=20
> > NIP [c0000000003a6280] .__scsi_alloc_queue+0x2c/0x13c
> > LR [c0000000003a63b4] .scsi_alloc_queue+0x24/0x84
> > Call Trace:
> > [c00000007c3f32a0] [c00000007c3f3330] 0xc00000007c3f3330 (unreliable)
> > [c00000007c3f3330] [c0000000003a63b4] .scsi_alloc_queue+0x24/0x84
> > [c00000007c3f33b0] [c0000000003a8f78] .scsi_alloc_sdev+0x198/0x2ac
> > [c00000007c3f3470] [c0000000003a9450] .scsi_probe_and_add_lun+0x130/0xa=
ac
> > [c00000007c3f3580] [c0000000003aa20c] .__scsi_scan_target+0xf4/0x5fc
> > [c00000007c3f36a0] [c0000000003aa768] .scsi_scan_channel+0x54/0xd0
> > [c00000007c3f3740] [c0000000003aa8b0] .scsi_scan_host_selected+0xcc/0x1=
44
> > [c00000007c3f37f0] [c0000000003d5264] .ibmvscsi_probe+0x590/0x6e4
> > [c00000007c3f38c0] [c000000000021e88] .vio_bus_probe+0x84/0xb0
> > [c00000007c3f3960] [c00000000037cbac] .driver_probe_device+0xfc/0x1c0
> > [c00000007c3f39f0] [c00000000037cd04] .__driver_attach+0x94/0xd8
> > [c00000007c3f3a80] [c00000000037b9f8] .bus_for_each_dev+0x84/0xdc
> > [c00000007c3f3b30] [c00000000037c954] .driver_attach+0x28/0x40
> > [c00000007c3f3bb0] [c00000000037c290] .bus_add_driver+0x148/0x314
> > [c00000007c3f3c60] [c00000000037d1b0] .driver_register+0xd4/0x1a8
> > [c00000007c3f3d10] [c000000000021cbc] .vio_register_driver+0x40/0x5c
> > [c00000007c3f3da0] [c00000000084f418] .ibmvscsi_module_init+0x80/0xb8
> > [c00000007c3f3e30] [c0000000000094c8] .do_one_initcall+0x9c/0x1cc
> > [c00000007c3f3ee0] [c000000000822cc0] .kernel_init+0x21c/0x298
> > [c00000007c3f3f90] [c000000000026cb8] .kernel_thread+0x54/0x70
> > Instruction dump:
> > 4e800020 7c0802a6 fb81ffe0 fbe1fff8 fba1ffe8 7c7c1b78 f8010010 f821ff71=
=20
> > 7c9f2378 eba302a0 48000008 ebbd0000 <e81d0058> 7fa3eb78 2fa00000 419eff=
f0=20
> > ---[ end trace 18604a042ee6e0ba ]---
> > Kernel panic - not syncing: Attempted to kill init!
> >=20
> > I have bisected this down to commit
> > 4acd10521ee002137b5d6791e234d7110033c782 ("[SCSI] scsi_lib_dma.c : fix
> > bug /w dma maps on virtual vc ports") which was added between
> > next-20090925 and next-20090926.
> >=20
> > Reverting that single commit from next-20090926 allows it to boot.
>=20
> OK, so my strongest suspicion is that the SCSI device is parented to
> some IBM specific device that has no type.  This is causing SCSI to
> wander up the tree until it hits a NULL device and panics on the deref.
>=20
> Does this incremental diff fix it?

That fixes the above panic, but leaves me with this:

calling  .ibmvscsi_module_init+0x0/0xb8 @ 1
ibmvscsi 30000028: SRP_VERSION: 16.a
scsi0 : IBM POWER Virtual SCSI Adapter 1.5.8
ibmvscsi 30000028: partner initialization complete
ibmvscsi 30000028: host srp version: 16.a, host partition 1-Didgo-VIOS (1),=
 OS 3, max io 1048576
ibmvscsi 30000028: Client reserve enabled
ibmvscsi 30000028: sent SRP login
ibmvscsi 30000028: SRP_LOGIN succeeded
Unable to handle kernel paging request for data at address 0x00000020
Faulting instruction address: 0xc0000000003a8798
Oops: Kernel access of bad area, sig: 11 [#1]
SMP NR_CPUS=3D128 NUMA pSeries
Modules linked in:
NIP: c0000000003a8798 LR: c0000000003a8774 CTR: 0000000000000000
REGS: c00000007c3f2aa0 TRAP: 0300   Not tainted  (2.6.31-autokern1-next-200=
90926)
MSR: 8000000000009032 <EE,ME,IR,DR>  CR: 44002022  XER: 00000001
DAR: 0000000000000020, DSISR: 0000000040000000
TASK =3D c00000007c3e8000[1] 'swapper' THREAD: c00000007c3f0000 CPU: 3
GPR00: 0000000000000000 c00000007c3f2d20 c000000000bc5390 0000000000000000=
=20
GPR04: 0000000000000000 0000000000000000 c00000007a3f0bc0 0000000000000000=
=20
GPR08: 0000000024000000 0000000000000000 c00000007a3f0ae0 0000000000000001=
=20
GPR12: 0000000048002022 c000000000c1ea80 0000000003500000 c00000000074af10=
=20
GPR16: c000000000749588 0000000000000000 c00000007c5d4800 0000000000000003=
=20
GPR20: c00000007c3f34f0 c000000000b96a20 c00000007c5d4628 c00000007c5d4638=
=20
GPR24: 0000000000000000 0000000000000000 0000000000000002 0000000000000001=
=20
GPR28: c00000007c6e7c00 0000000000000002 c000000000b37630 c000000000a76420=
=20
NIP [c0000000003a8798] .scsi_dma_map+0xc8/0x130
LR [c0000000003a8774] .scsi_dma_map+0xa4/0x130
Call Trace:
[c00000007c3f2d20] [c00000007c3e8000] 0xc00000007c3e8000 (unreliable)
[c00000007c3f2dd0] [c0000000003d603c] .ibmvscsi_queuecommand+0x16c/0x570
[c00000007c3f2ea0] [c00000000039f968] .scsi_dispatch_cmd+0x1d4/0x240
[c00000007c3f2f40] [c0000000003a7cbc] .scsi_request_fn+0x434/0x47c
[c00000007c3f2fe0] [c0000000002d0c4c] .__generic_unplug_device+0x60/0x78
[c00000007c3f3060] [c0000000002dacec] .blk_execute_rq_nowait+0x70/0xcc
[c00000007c3f30f0] [c0000000002dae24] .blk_execute_rq+0xdc/0x134
[c00000007c3f32b0] [c0000000003a6fe8] .scsi_execute+0x120/0x1b4
[c00000007c3f3380] [c0000000003a71b0] .scsi_execute_req+0x134/0x1c0
[c00000007c3f3470] [c0000000003a95b8] .scsi_probe_and_add_lun+0x274/0xaac
[c00000007c3f3580] [c0000000003aa230] .__scsi_scan_target+0xf4/0x5fc
[c00000007c3f36a0] [c0000000003aa78c] .scsi_scan_channel+0x54/0xd0
[c00000007c3f3740] [c0000000003aa8d4] .scsi_scan_host_selected+0xcc/0x144
[c00000007c3f37f0] [c0000000003d5288] .ibmvscsi_probe+0x590/0x6e4
[c00000007c3f38c0] [c000000000021e88] .vio_bus_probe+0x84/0xb0
[c00000007c3f3960] [c00000000037cbac] .driver_probe_device+0xfc/0x1c0
[c00000007c3f39f0] [c00000000037cd04] .__driver_attach+0x94/0xd8
[c00000007c3f3a80] [c00000000037b9f8] .bus_for_each_dev+0x84/0xdc
[c00000007c3f3b30] [c00000000037c954] .driver_attach+0x28/0x40
[c00000007c3f3bb0] [c00000000037c290] .bus_add_driver+0x148/0x314
[c00000007c3f3c60] [c00000000037d1b0] .driver_register+0xd4/0x1a8
[c00000007c3f3d10] [c000000000021cbc] .vio_register_driver+0x40/0x5c
[c00000007c3f3da0] [c00000000084f418] .ibmvscsi_module_init+0x80/0xb8
[c00000007c3f3e30] [c0000000000094c8] .do_one_initcall+0x9c/0x1cc
[c00000007c3f3ee0] [c000000000822cc0] .kernel_init+0x21c/0x298
[c00000007c3f3f90] [c000000000026cb8] .kernel_thread+0x54/0x70
Instruction dump:
3ba00000 4800000c 4bf4f689 60000000 7f9dd800 381d0001 7c1d07b4 419cffec=20
2b9a0002 7c000026 5400f7fe 0b000000 <e9390020> 7fe3fb78 7f84e378 7f65db78=20
---[ end trace fe14497cda58c66c ]---
Kernel panic - not syncing: Attempted to kill init!

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__29_Sep_2009_11_27_04_+1000_kj21e/zFy650E1Ar
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkrBYmkACgkQjjKRsyhoI8yHsQCfQMq//VHzbUtbDzuWhujfuIpv
5J4AoINghamiBdpYJCNb/Uj3PDnTIKXI
=04Dm
-----END PGP SIGNATURE-----

--Signature=_Tue__29_Sep_2009_11_27_04_+1000_kj21e/zFy650E1Ar--
