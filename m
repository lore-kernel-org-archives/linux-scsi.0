From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: BUG: KASAN: slab-out-of-bounds in
 ses_enclosure_data_process+0x900/0xe50
Date: Wed, 02 Dec 2015 14:58:21 -0800
Message-ID: <1449097101.2203.67.camel@HansenPartnership.com>
References: <20151201202053.GA4753@glen>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-4lU3ZIPYeWQSzymAv5qa"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151201202053.GA4753@glen>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrea Gelmini <andrea.gelmini@gelma.net>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


--=-4lU3ZIPYeWQSzymAv5qa
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2015-12-01 at 21:20 +0100, Andrea Gelmini wrote:
> Hi everybody,
>    and thanks a lot for your work.
>=20
>    As soon as I plugged an external WD USB hard drive (details in the att=
ached file)
>    into USB3 port, I've got this (much more info in the attached files).
>    Using commit 2255702db4014d1c69d6037ed7bdad2d2e271985
>=20
> Thanks again,
> Andrea
>=20
> [  542.582204] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> [  542.582220] BUG: KASAN: slab-out-of-bounds in ses_enclosure_data_proce=
ss+0x900/0xe50 [ses] at addr ffff88038c421c12
> [  542.582223] Read of size 1 by task systemd-udevd/4017
> [  542.582225] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
> [  542.582227] BUG kmalloc-8 (Not tainted): kasan: bad access detected
> [  542.582228] ----------------------------------------------------------=
-------------------
>=20
> [  542.582229] Disabling lock debugging due to kernel taint
> [  542.582236] INFO: Allocated in ses_enclosure_data_process+0x1e6/0xe50 =
[ses] age=3D1 cpu=3D2 pid=3D4017
> [  542.582243]  ___slab_alloc.constprop.27+0x379/0x3a0
> [  542.582246]  __slab_alloc.isra.24.constprop.26+0x26/0x40
> [  542.582249]  __kmalloc+0x19b/0x1e0
> [  542.582253]  ses_enclosure_data_process+0x1e6/0xe50 [ses]
> [  542.582256]  ses_intf_add+0x9d6/0xe00 [ses]
> [  542.582261]  class_interface_register+0x213/0x350
> [  542.582264]  scsi_register_interface+0x33/0x40
> [  542.582268]  ses_init+0x13/0x1000 [ses]
> [  542.582272]  do_one_initcall+0x13c/0x2f0
> [  542.582277]  do_init_module+0x1d9/0x5bc
> [  542.582280]  load_module+0x6029/0x9230
> [  542.582283]  SyS_finit_module+0x103/0x130
> [  542.582288]  entry_SYSCALL_64_fastpath+0x16/0x75
> [  542.582293] INFO: Freed in sg_clean+0x12e/0x200 age=3D1 cpu=3D3 pid=3D=
4009
> [  542.582296]  __slab_free+0x292/0x3d0
> [  542.582298]  kfree+0x108/0x120
> [  542.582300]  sg_clean+0x12e/0x200
> [  542.582302]  usb_sg_wait+0x2ad/0x3d0
> [  542.582307]  usb_stor_bulk_transfer_sglist.part.3+0xc4/0x200 [usb_stor=
age]
> [  542.582311]  usb_stor_bulk_srb+0x184/0x280 [usb_storage]
> [  542.582315]  usb_stor_Bulk_transport+0x53e/0xf80 [usb_storage]
> [  542.582319]  usb_stor_invoke_transport+0xf2/0x1430 [usb_storage]
> [  542.582323]  usb_stor_transparent_scsi_command+0x9/0x10 [usb_storage]
> [  542.582327]  usb_stor_control_thread+0x530/0xac0 [usb_storage]
> [  542.582332]  kthread+0x1c0/0x260
> [  542.582335]  ret_from_fork+0x3f/0x70
> [  542.582339] INFO: Slab 0xffffea000e310800 objects=3D26 used=3D25 fp=3D=
0xffff88038c421e78 flags=3D0x8000000000004080
> [  542.582341] INFO: Object 0xffff88038c421c08 @offset=3D7176 fp=3D0x0000=
000000000008
>=20
> [  542.582345] Bytes b4 ffff88038c421bf8: 01 00 00 00 01 00 00 00 74 97 f=
d ff 00 00 00 00  ........t.......
> [  542.582348] Object ffff88038c421c08: 08 00 00 00 00 00 00 00          =
                ........
> [  542.582354] CPU: 2 PID: 4017 Comm: systemd-udevd Tainted: G    B      =
     4.4.0-rc3KASan-00005-g2255702 #5
> [  542.582356] Hardware name: LENOVO 2356LRG/2356LRG, BIOS G7ETA3WW (2.63=
 ) 04/16/2015
> [  542.582361]  ffff88038c420000 ffff8800ac3ff6c0 ffffffff819c3387 ffff88=
038e404240
> [  542.582365]  ffff8800ac3ff6f0 ffffffff813e22f4 ffff88038e404240 ffffea=
000e310800
> [  542.582368]  ffff88038c421c08 0000000000000000 ffff8800ac3ff718 ffffff=
ff813e69bf
> [  542.582369] Call Trace:
> [  542.582375]  [<ffffffff819c3387>] dump_stack+0x4b/0x74
> [  542.582378]  [<ffffffff813e22f4>] print_trailer+0xf4/0x150
> [  542.582382]  [<ffffffff813e69bf>] object_err+0x2f/0x40
> [  542.582387]  [<ffffffff813e85fc>] kasan_report_error+0x21c/0x540
> [  542.582392]  [<ffffffffc130842c>] ? ses_recv_diag+0xac/0xe0 [ses]
> [  542.582397]  [<ffffffff813e895e>] __asan_report_load1_noabort+0x3e/0x4=
0
> [  542.582401]  [<ffffffffc1309490>] ? ses_enclosure_data_process+0x900/0=
xe50 [ses]
> [  542.582406]  [<ffffffffc1309490>] ses_enclosure_data_process+0x900/0xe=
50 [ses]
> [  542.582412]  [<ffffffff81d5d454>] ? pm_runtime_init+0x364/0x410
> [  542.582417]  [<ffffffffc130a806>] ses_intf_add+0x9d6/0xe00 [ses]
> [  542.582421]  [<ffffffff81d45183>] class_interface_register+0x213/0x350
> [  542.582425]  [<ffffffff81d44f70>] ? class_dev_iter_exit+0x10/0x10
> [  542.582429]  [<ffffffff819f44a0>] ? kvasprintf+0xf0/0xf0
> [  542.582432]  [<ffffffffc1130000>] ? 0xffffffffc1130000
> [  542.582435]  [<ffffffff81dff163>] scsi_register_interface+0x33/0x40
> [  542.582439]  [<ffffffffc1130013>] ses_init+0x13/0x1000 [ses]
> [  542.582443]  [<ffffffff810021ac>] do_one_initcall+0x13c/0x2f0
> [  542.582446]  [<ffffffff81002070>] ? try_to_run_init_process+0x40/0x40
> [  542.582450]  [<ffffffff813e7d06>] ? kasan_unpoison_shadow+0x36/0x50
> [  542.582454]  [<ffffffff813e7d06>] ? kasan_unpoison_shadow+0x36/0x50
> [  542.582458]  [<ffffffff813e7e17>] ? __asan_register_globals+0x87/0xa0
> [  542.582463]  [<ffffffff813199fd>] do_init_module+0x1d9/0x5bc
> [  542.582466]  [<ffffffff8124d669>] load_module+0x6029/0x9230
> [  542.582469]  [<ffffffff81245430>] ? symbol_put_addr+0x50/0x50
> [  542.582475]  [<ffffffff81247640>] ? module_frob_arch_sections+0x20/0x2=
0
> [  542.582479]  [<ffffffff8142de90>] ? open_exec+0x50/0x50
> [  542.582486]  [<ffffffff8111b9ff>] ? ns_capable+0x4f/0xd0
> [  542.582489]  [<ffffffff81250b43>] SyS_finit_module+0x103/0x130
> [  542.582492]  [<ffffffff81250a40>] ? SyS_init_module+0x1d0/0x1d0
> [  542.582497]  [<ffffffff824c6df6>] entry_SYSCALL_64_fastpath+0x16/0x75
> [  542.582498] Memory state around the buggy address:
> [  542.582501]  ffff88038c421b00: fc fc fc fc fc fc fc fc fc fc fc fc fc =
fc fc fc
> [  542.582503]  ffff88038c421b80: fc fc fc fc fc fc fc fc fc fc fc fc fc =
fc fc fc
> [  542.582506] >ffff88038c421c00: fc 05 fc fc fc fc fc fc fc fc fc fc fc =
fc fc fc
> [  542.582507]                          ^
> [  542.582509]  ffff88038c421c80: fc fc fc fc fc fc fc fc fc fc fc fc fc =
fc fc fc
> [  542.582512]  ffff88038c421d00: fc fc fc fc fc fc fc fc 00 fc fc fc fc =
fc fc fc
> [  542.582513] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> [  542.582514] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> [  542.582519] BUG: KASAN: slab-out-of-bounds in ses_enclosure_data_proce=
ss+0xe3b/0xe50 [ses] at addr ffff88038c421c13
> [  542.582521] Read of size 1 by task systemd-udevd/4017
> [  542.582521] Read of size 1 by task systemd-udevd/4017
> [  542.582522] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
> [  542.582524] BUG kmalloc-8 (Tainted: G    B          ): kasan: bad acce=
ss detected
> [  542.582525] ----------------------------------------------------------=
-------------------
>=20
> [  542.582530] INFO: Allocated in ses_enclosure_data_process+0x1e6/0xe50 =
[ses] age=3D1 cpu=3D2 pid=3D4017
> [  542.582533]  ___slab_alloc.constprop.27+0x379/0x3a0
> [  542.582536]  __slab_alloc.isra.24.constprop.26+0x26/0x40
> [  542.582539]  __kmalloc+0x19b/0x1e0
> [  542.582542]  ses_enclosure_data_process+0x1e6/0xe50 [ses]
> [  542.582546]  ses_intf_add+0x9d6/0xe00 [ses]
> [  542.582549]  class_interface_register+0x213/0x350
> [  542.582551]  scsi_register_interface+0x33/0x40
> [  542.582555]  ses_init+0x13/0x1000 [ses]
> [  542.582557]  do_one_initcall+0x13c/0x2f0
> [  542.582560]  do_init_module+0x1d9/0x5bc
> [  542.582562]  load_module+0x6029/0x9230
> [  542.582564]  SyS_finit_module+0x103/0x130
> [  542.582568]  entry_SYSCALL_64_fastpath+0x16/0x75
> [  542.582571] INFO: Freed in sg_clean+0x12e/0x200 age=3D1 cpu=3D3 pid=3D=
4009
> [  542.582574]  __slab_free+0x292/0x3d0
> [  542.582577]  kfree+0x108/0x120
> [  542.582578]  sg_clean+0x12e/0x200
> [  542.582580]  usb_sg_wait+0x2ad/0x3d0
> [  542.582585]  usb_stor_bulk_transfer_sglist.part.3+0xc4/0x200 [usb_stor=
age]
> [  542.582588]  usb_stor_bulk_srb+0x184/0x280 [usb_storage]
> [  542.582592]  usb_stor_Bulk_transport+0x53e/0xf80 [usb_storage]
> [  542.582596]  usb_stor_invoke_transport+0xf2/0x1430 [usb_storage]
> [  542.582599]  usb_stor_transparent_scsi_command+0x9/0x10 [usb_storage]
> [  542.582603]  usb_stor_control_thread+0x530/0xac0 [usb_storage]
> [  542.582606]  kthread+0x1c0/0x260
> [  542.582610]  ret_from_fork+0x3f/0x70
> [  542.582612] INFO: Slab 0xffffea000e310800 objects=3D26 used=3D25 fp=3D=
0xffff88038c421e78 flags=3D0x8000000000004080
> [  542.582614] INFO: Object 0xffff88038c421c08 @offset=3D7176 fp=3D0x0000=
000000000008
>=20
> [  542.582617] Bytes b4 ffff88038c421bf8: 01 00 00 00 01 00 00 00 74 97 f=
d ff 00 00 00 00  ........t.......
> [  542.582620] Object ffff88038c421c08: 08 00 00 00 00 00 00 00          =
                ........
> [  542.582623] CPU: 2 PID: 4017 Comm: systemd-udevd Tainted: G    B      =
     4.4.0-rc3KASan-00005-g2255702 #5
> [  542.582625] Hardware name: LENOVO 2356LRG/2356LRG, BIOS G7ETA3WW (2.63=
 ) 04/16/2015
> [  542.582628]  ffff88038c420000 ffff8800ac3ff6c0 ffffffff819c3387 ffff88=
038e404240
> [  542.582632]  ffff8800ac3ff6f0 ffffffff813e22f4 ffff88038e404240 ffffea=
000e310800
> [  542.582635]  ffff88038c421c08 0000000000000000 ffff8800ac3ff718 ffffff=
ff813e69bf
> [  542.582636] Call Trace:
> [  542.582639]  [<ffffffff819c3387>] dump_stack+0x4b/0x74
> [  542.582642]  [<ffffffff813e22f4>] print_trailer+0xf4/0x150
> [  542.582645]  [<ffffffff813e69bf>] object_err+0x2f/0x40
> [  542.582649]  [<ffffffff813e85fc>] kasan_report_error+0x21c/0x540
> [  542.582654]  [<ffffffff813e895e>] __asan_report_load1_noabort+0x3e/0x4=
0
> [  542.582659]  [<ffffffffc13099cb>] ? ses_enclosure_data_process+0xe3b/0=
xe50 [ses]
> [  542.582663]  [<ffffffffc13099cb>] ses_enclosure_data_process+0xe3b/0xe=
50 [ses]
> [  542.582667]  [<ffffffff81d5d454>] ? pm_runtime_init+0x364/0x410
> [  542.582672]  [<ffffffffc130a806>] ses_intf_add+0x9d6/0xe00 [ses]
> [  542.582676]  [<ffffffff81d45183>] class_interface_register+0x213/0x350
> [  542.582680]  [<ffffffff81d44f70>] ? class_dev_iter_exit+0x10/0x10
> [  542.582683]  [<ffffffff819f44a0>] ? kvasprintf+0xf0/0xf0
> [  542.582686]  [<ffffffffc1130000>] ? 0xffffffffc1130000
> [  542.582689]  [<ffffffff81dff163>] scsi_register_interface+0x33/0x40
> [  542.582693]  [<ffffffffc1130013>] ses_init+0x13/0x1000 [ses]
> [  542.582696]  [<ffffffff810021ac>] do_one_initcall+0x13c/0x2f0
> [  542.582699]  [<ffffffff81002070>] ? try_to_run_init_process+0x40/0x40
> [  542.582703]  [<ffffffff813e7d06>] ? kasan_unpoison_shadow+0x36/0x50
> [  542.582707]  [<ffffffff813e7d06>] ? kasan_unpoison_shadow+0x36/0x50
> [  542.582711]  [<ffffffff813e7e17>] ? __asan_register_globals+0x87/0xa0
> [  542.582715]  [<ffffffff813199fd>] do_init_module+0x1d9/0x5bc
> [  542.582718]  [<ffffffff8124d669>] load_module+0x6029/0x9230
> [  542.582721]  [<ffffffff81245430>] ? symbol_put_addr+0x50/0x50
> [  542.582727]  [<ffffffff81247640>] ? module_frob_arch_sections+0x20/0x2=
0
> [  542.582730]  [<ffffffff8142de90>] ? open_exec+0x50/0x50
> [  542.582735]  [<ffffffff8111b9ff>] ? ns_capable+0x4f/0xd0
> [  542.582738]  [<ffffffff81250b43>] SyS_finit_module+0x103/0x130
> [  542.582741]  [<ffffffff81250a40>] ? SyS_init_module+0x1d0/0x1d0
> [  542.582746]  [<ffffffff824c6df6>] entry_SYSCALL_64_fastpath+0x16/0x75
> [  542.582747] Memory state around the buggy address:
> [  542.582750]  ffff88038c421b00: fc fc fc fc fc fc fc fc fc fc fc fc fc =
fc fc fc
> [  542.582752]  ffff88038c421b80: fc fc fc fc fc fc fc fc fc fc fc fc fc =
fc fc fc
> [  542.582754] >ffff88038c421c00: fc 05 fc fc fc fc fc fc fc fc fc fc fc =
fc fc fc
> [  542.582755]                          ^
> [  542.582757]  ffff88038c421c80: fc fc fc fc fc fc fc fc fc fc fc fc fc =
fc fc fc
> [  542.582759]  ffff88038c421d00: fc fc fc fc fc fc fc fc 00 fc fc fc fc =
fc fc fc
> [  542.582760] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> [  542.584193] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> [  542.584206] BUG: KASAN: slab-out-of-bounds in ses_enclosure_data_proce=
ss+0x900/0xe50 [ses] at addr ffff88038c421c12
> [  542.584209] Read of size 1 by task systemd-udevd/4017
> [  542.584210] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
> [  542.584212] BUG kmalloc-8 (Tainted: G    B          ): kasan: bad acce=
ss detected
> [  542.584213] ----------------------------------------------------------=
-------------------
>=20
> [  542.584219] INFO: Allocated in ses_enclosure_data_process+0x1e6/0xe50 =
[ses] age=3D1 cpu=3D2 pid=3D4017
> [  542.584223]  ___slab_alloc.constprop.27+0x379/0x3a0
> [  542.584226]  __slab_alloc.isra.24.constprop.26+0x26/0x40
> [  542.584229]  __kmalloc+0x19b/0x1e0
> [  542.584232]  ses_enclosure_data_process+0x1e6/0xe50 [ses]
> [  542.584236]  ses_match_to_enclosure+0xb5/0x450 [ses]
> [  542.584239]  ses_intf_add+0xaa0/0xe00 [ses]
> [  542.584243]  class_interface_register+0x213/0x350
> [  542.584245]  scsi_register_interface+0x33/0x40
> [  542.584249]  ses_init+0x13/0x1000 [ses]
> [  542.584252]  do_one_initcall+0x13c/0x2f0
> [  542.584255]  do_init_module+0x1d9/0x5bc
> [  542.584258]  load_module+0x6029/0x9230
> [  542.584260]  SyS_finit_module+0x103/0x130
> [  542.584264]  entry_SYSCALL_64_fastpath+0x16/0x75
> [  542.584267] INFO: Freed in sg_clean+0x12e/0x200 age=3D1 cpu=3D3 pid=3D=
4009
> [  542.584270]  __slab_free+0x292/0x3d0
> [  542.584273]  kfree+0x108/0x120
> [  542.584275]  sg_clean+0x12e/0x200
> [  542.584277]  usb_sg_wait+0x2ad/0x3d0
> [  542.584281]  usb_stor_bulk_transfer_sglist.part.3+0xc4/0x200 [usb_stor=
age]
> [  542.584285]  usb_stor_bulk_srb+0x184/0x280 [usb_storage]
> [  542.584288]  usb_stor_Bulk_transport+0x53e/0xf80 [usb_storage]
> [  542.584292]  usb_stor_invoke_transport+0xf2/0x1430 [usb_storage]
> [  542.584296]  usb_stor_transparent_scsi_command+0x9/0x10 [usb_storage]
> [  542.584300]  usb_stor_control_thread+0x530/0xac0 [usb_storage]
> [  542.584303]  kthread+0x1c0/0x260
> [  542.584307]  ret_from_fork+0x3f/0x70
> [  542.584310] INFO: Slab 0xffffea000e310800 objects=3D26 used=3D25 fp=3D=
0xffff88038c421e78 flags=3D0x8000000000004080
> [  542.584311] INFO: Object 0xffff88038c421c08 @offset=3D7176 fp=3D0x0000=
000000000008
>=20
> [  542.584315] Bytes b4 ffff88038c421bf8: 01 00 00 00 01 00 00 00 74 97 f=
d ff 00 00 00 00  ........t.......
> [  542.584317] Object ffff88038c421c08: 08 00 00 00 00 00 00 00          =
                ........
> [  542.584321] CPU: 2 PID: 4017 Comm: systemd-udevd Tainted: G    B      =
     4.4.0-rc3KASan-00005-g2255702 #5
> [  542.584323] Hardware name: LENOVO 2356LRG/2356LRG, BIOS G7ETA3WW (2.63=
 ) 04/16/2015
> [  542.584327]  ffff88038c420000 ffff8800ac3ff5f8 ffffffff819c3387 ffff88=
038e404240
> [  542.584331]  ffff8800ac3ff628 ffffffff813e22f4 ffff88038e404240 ffffea=
000e310800
> [  542.584334]  ffff88038c421c08 0000000000000000 ffff8800ac3ff650 ffffff=
ff813e69bf
> [  542.584335] Call Trace:
> [  542.584338]  [<ffffffff819c3387>] dump_stack+0x4b/0x74
> [  542.584342]  [<ffffffff813e22f4>] print_trailer+0xf4/0x150
> [  542.584345]  [<ffffffff813e69bf>] object_err+0x2f/0x40
> [  542.584349]  [<ffffffff813e85fc>] kasan_report_error+0x21c/0x540
> [  542.584354]  [<ffffffffc130842c>] ? ses_recv_diag+0xac/0xe0 [ses]
> [  542.584358]  [<ffffffff813e895e>] __asan_report_load1_noabort+0x3e/0x4=
0
> [  542.584363]  [<ffffffffc1309490>] ? ses_enclosure_data_process+0x900/0=
xe50 [ses]
> [  542.584367]  [<ffffffffc1309490>] ses_enclosure_data_process+0x900/0xe=
50 [ses]
> [  542.584371]  [<ffffffff813e884a>] ? kasan_report_error+0x46a/0x540
> [  542.584376]  [<ffffffffc1309a95>] ses_match_to_enclosure+0xb5/0x450 [s=
es]
> [  542.584380]  [<ffffffffc13093b0>] ? ses_enclosure_data_process+0x820/0=
xe50 [ses]
> [  542.584385]  [<ffffffffc13099e0>] ? ses_enclosure_data_process+0xe50/0=
xe50 [ses]
> [  542.584389]  [<ffffffff81dd1a13>] ? __scsi_iterate_devices+0xf3/0x240
> [  542.584394]  [<ffffffffc130a8d0>] ses_intf_add+0xaa0/0xe00 [ses]
> [  542.584398]  [<ffffffff81d45183>] class_interface_register+0x213/0x350
> [  542.584402]  [<ffffffff81d44f70>] ? class_dev_iter_exit+0x10/0x10
> [  542.584405]  [<ffffffff819f44a0>] ? kvasprintf+0xf0/0xf0
> [  542.584408]  [<ffffffffc1130000>] ? 0xffffffffc1130000
> [  542.584411]  [<ffffffff81dff163>] scsi_register_interface+0x33/0x40
> [  542.584415]  [<ffffffffc1130013>] ses_init+0x13/0x1000 [ses]
> [  542.584418]  [<ffffffff810021ac>] do_one_initcall+0x13c/0x2f0
> [  542.584421]  [<ffffffff81002070>] ? try_to_run_init_process+0x40/0x40
> [  542.584425]  [<ffffffff813e7d06>] ? kasan_unpoison_shadow+0x36/0x50
> [  542.584429]  [<ffffffff813e7d06>] ? kasan_unpoison_shadow+0x36/0x50
> [  542.584433]  [<ffffffff813e7e17>] ? __asan_register_globals+0x87/0xa0
> [  542.584438]  [<ffffffff813199fd>] do_init_module+0x1d9/0x5bc
> [  542.584441]  [<ffffffff8124d669>] load_module+0x6029/0x9230
> [  542.584444]  [<ffffffff81245430>] ? symbol_put_addr+0x50/0x50
> [  542.584450]  [<ffffffff81247640>] ? module_frob_arch_sections+0x20/0x2=
0
> [  542.584453]  [<ffffffff8142de90>] ? open_exec+0x50/0x50
> [  542.584458]  [<ffffffff8111b9ff>] ? ns_capable+0x4f/0xd0
> [  542.584461]  [<ffffffff81250b43>] SyS_finit_module+0x103/0x130
> [  542.584464]  [<ffffffff81250a40>] ? SyS_init_module+0x1d0/0x1d0
> [  542.584469]  [<ffffffff824c6df6>] entry_SYSCALL_64_fastpath+0x16/0x75
> [  542.584470] Memory state around the buggy address:
> [  542.584473]  ffff88038c421b00: fc fc fc fc fc fc fc fc fc fc fc fc fc =
fc fc fc
> [  542.584475]  ffff88038c421b80: fc fc fc fc fc fc fc fc fc fc fc fc fc =
fc fc fc
> [  542.584478] >ffff88038c421c00: fc 05 fc fc fc fc fc fc fc fc fc fc fc =
fc fc fc
> [  542.584479]                          ^
> [  542.584481]  ffff88038c421c80: fc fc fc fc fc fc fc fc fc fc fc fc fc =
fc fc fc
> [  542.584483]  ffff88038c421d00: fc fc fc fc fc fc fc fc 00 fc fc fc fc =
fc fc fc
> [  542.584484] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> [  542.584485] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> [  542.584490] BUG: KASAN: slab-out-of-bounds in ses_enclosure_data_proce=
ss+0xe3b/0xe50 [ses] at addr ffff88038c421c13
> [  542.584492] Read of size 1 by task systemd-udevd/4017
> [  542.584493] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
> [  542.584495] BUG kmalloc-8 (Tainted: G    B          ): kasan: bad acce=
ss detected
> [  542.584496] ----------------------------------------------------------=
-------------------
>=20
> [  542.584501] INFO: Allocated in ses_enclosure_data_process+0x1e6/0xe50 =
[ses] age=3D1 cpu=3D2 pid=3D4017
> [  542.584504]  ___slab_alloc.constprop.27+0x379/0x3a0
> [  542.584507]  __slab_alloc.isra.24.constprop.26+0x26/0x40
> [  542.584510]  __kmalloc+0x19b/0x1e0
> [  542.584513]  ses_enclosure_data_process+0x1e6/0xe50 [ses]
> [  542.584517]  ses_match_to_enclosure+0xb5/0x450 [ses]
> [  542.584520]  ses_intf_add+0xaa0/0xe00 [ses]
> [  542.584523]  class_interface_register+0x213/0x350
> [  542.584525]  scsi_register_interface+0x33/0x40
> [  542.584529]  ses_init+0x13/0x1000 [ses]
> [  542.584531]  do_one_initcall+0x13c/0x2f0
> [  542.584534]  do_init_module+0x1d9/0x5bc
> [  542.584536]  load_module+0x6029/0x9230
> [  542.584538]  SyS_finit_module+0x103/0x130
> [  542.584542]  entry_SYSCALL_64_fastpath+0x16/0x75
> [  542.584545] INFO: Freed in sg_clean+0x12e/0x200 age=3D1 cpu=3D3 pid=3D=
4009
> [  542.584548]  __slab_free+0x292/0x3d0
> [  542.584550]  kfree+0x108/0x120
> [  542.584552]  sg_clean+0x12e/0x200
> [  542.584554]  usb_sg_wait+0x2ad/0x3d0
> [  542.584558]  usb_stor_bulk_transfer_sglist.part.3+0xc4/0x200 [usb_stor=
age]
> [  542.584562]  usb_stor_bulk_srb+0x184/0x280 [usb_storage]
> [  542.584565]  usb_stor_Bulk_transport+0x53e/0xf80 [usb_storage]
> [  542.584569]  usb_stor_invoke_transport+0xf2/0x1430 [usb_storage]
> [  542.584573]  usb_stor_transparent_scsi_command+0x9/0x10 [usb_storage]
> [  542.584577]  usb_stor_control_thread+0x530/0xac0 [usb_storage]
> [  542.584580]  kthread+0x1c0/0x260
> [  542.584583]  ret_from_fork+0x3f/0x70
> [  542.584585] INFO: Slab 0xffffea000e310800 objects=3D26 used=3D25 fp=3D=
0xffff88038c421e78 flags=3D0x8000000000004080
> [  542.584587] INFO: Object 0xffff88038c421c08 @offset=3D7176 fp=3D0x0000=
000000000008
>=20
> [  542.584590] Bytes b4 ffff88038c421bf8: 01 00 00 00 01 00 00 00 74 97 f=
d ff 00 00 00 00  ........t.......
> [  542.584592] Object ffff88038c421c08: 08 00 00 00 00 00 00 00          =
                ........
> [  542.584596] CPU: 2 PID: 4017 Comm: systemd-udevd Tainted: G    B      =
     4.4.0-rc3KASan-00005-g2255702 #5
> [  542.584597] Hardware name: LENOVO 2356LRG/2356LRG, BIOS G7ETA3WW (2.63=
 ) 04/16/2015
> [  542.584601]  ffff88038c420000 ffff8800ac3ff5f8 ffffffff819c3387 ffff88=
038e404240
> [  542.584604]  ffff8800ac3ff628 ffffffff813e22f4 ffff88038e404240 ffffea=
000e310800
> [  542.584607]  ffff88038c421c08 0000000000000000 ffff8800ac3ff650 ffffff=
ff813e69bf
> [  542.584608] Call Trace:
> [  542.584611]  [<ffffffff819c3387>] dump_stack+0x4b/0x74
> [  542.584614]  [<ffffffff813e22f4>] print_trailer+0xf4/0x150
> [  542.584617]  [<ffffffff813e69bf>] object_err+0x2f/0x40
> [  542.584621]  [<ffffffff813e85fc>] kasan_report_error+0x21c/0x540
> [  542.584626]  [<ffffffff813e895e>] __asan_report_load1_noabort+0x3e/0x4=
0
> [  542.584630]  [<ffffffffc13099cb>] ? ses_enclosure_data_process+0xe3b/0=
xe50 [ses]
> [  542.584635]  [<ffffffffc13099cb>] ses_enclosure_data_process+0xe3b/0xe=
50 [ses]
> [  542.584638]  [<ffffffff813e884a>] ? kasan_report_error+0x46a/0x540
> [  542.584643]  [<ffffffffc1309a95>] ses_match_to_enclosure+0xb5/0x450 [s=
es]
> [  542.584647]  [<ffffffffc13093b0>] ? ses_enclosure_data_process+0x820/0=
xe50 [ses]
> [  542.584652]  [<ffffffffc13099e0>] ? ses_enclosure_data_process+0xe50/0=
xe50 [ses]
> [  542.584655]  [<ffffffff81dd1a13>] ? __scsi_iterate_devices+0xf3/0x240
> [  542.584660]  [<ffffffffc130a8d0>] ses_intf_add+0xaa0/0xe00 [ses]
> [  542.584664]  [<ffffffff81d45183>] class_interface_register+0x213/0x350
> [  542.584668]  [<ffffffff81d44f70>] ? class_dev_iter_exit+0x10/0x10
> [  542.584671]  [<ffffffff819f44a0>] ? kvasprintf+0xf0/0xf0
> [  542.584674]  [<ffffffffc1130000>] ? 0xffffffffc1130000
> [  542.584677]  [<ffffffff81dff163>] scsi_register_interface+0x33/0x40
> [  542.584681]  [<ffffffffc1130013>] ses_init+0x13/0x1000 [ses]
> [  542.584684]  [<ffffffff810021ac>] do_one_initcall+0x13c/0x2f0
> [  542.584687]  [<ffffffff81002070>] ? try_to_run_init_process+0x40/0x40
> [  542.584691]  [<ffffffff813e7d06>] ? kasan_unpoison_shadow+0x36/0x50
> [  542.584694]  [<ffffffff813e7d06>] ? kasan_unpoison_shadow+0x36/0x50
> [  542.584698]  [<ffffffff813e7e17>] ? __asan_register_globals+0x87/0xa0
> [  542.584703]  [<ffffffff813199fd>] do_init_module+0x1d9/0x5bc
> [  542.584706]  [<ffffffff8124d669>] load_module+0x6029/0x9230
> [  542.584709]  [<ffffffff81245430>] ? symbol_put_addr+0x50/0x50
> [  542.584715]  [<ffffffff81247640>] ? module_frob_arch_sections+0x20/0x2=
0
> [  542.584718]  [<ffffffff8142de90>] ? open_exec+0x50/0x50
> [  542.584723]  [<ffffffff8111b9ff>] ? ns_capable+0x4f/0xd0
> [  542.584726]  [<ffffffff81250b43>] SyS_finit_module+0x103/0x130
> [  542.584728]  [<ffffffff81250a40>] ? SyS_init_module+0x1d0/0x1d0
> [  542.584733]  [<ffffffff824c6df6>] entry_SYSCALL_64_fastpath+0x16/0x75
> [  542.584735] Memory state around the buggy address:
> [  542.584737]  ffff88038c421b00: fc fc fc fc fc fc fc fc fc fc fc fc fc =
fc fc fc
> [  542.584739]  ffff88038c421b80: fc fc fc fc fc fc fc fc fc fc fc fc fc =
fc fc fc
> [  542.584741] >ffff88038c421c00: fc 05 fc fc fc fc fc fc fc fc fc fc fc =
fc fc fc
> [  542.584742]                          ^
> [  542.584744]  ffff88038c421c80: fc fc fc fc fc fc fc fc fc fc fc fc fc =
fc fc fc
> [  542.584747]  ffff88038c421d00: fc fc fc fc fc fc fc fc 00 fc fc fc fc =
fc fc fc
> [  542.584748] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> [  542.585112] ses 6:0:0:1: Attached Enclosure device
> [  542.897281] sd 6:0:0:0: [sdb] Assuming drive cache: write through
> [  542.975864] sd 6:0:0:0: [sdb] Attached SCSI disk


OK, this looks like some type of problem with a USB enclosure.  It's
probably misreporting something in the mode pages.  can you run sg_ses
on whatever /dev/sg<n> the enclosure turns up as?

Thanks,

James


--=-4lU3ZIPYeWQSzymAv5qa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABCAAGBQJWX3eNAAoJEDeqqVYsXL0MwnEH/iikN07cFLDYcqWLRUB7xXT9
t7aHTqvgf91w07jd1IYI9FqRT4Dos3Kypp3DBrE4pEyxO1vPeZcDnggc95uxdUwT
B92N4jghEluVprzUhcg6JMoRT6tMvFR0zt74LO8UAdxFfxRl3G2hLup5D2Q3qeD1
N57+keBy34mZP/V9hvNoWlqfwwYndZaQFxE6fSVHOz7O6smQ5wrAiCLEYiDbAgh0
/OIh1QF8JViXdNWhTlXsZtzWEmGe8+epCpuJToQYVGEJ2ALcjCyIrajoDiiJICZZ
i+JMShGcq51fRVcbFHQrx+khzpjbuvV10MwrvSDNLvviNtgZYw2fEFr8zbqEnOE=
=XNID
-----END PGP SIGNATURE-----

--=-4lU3ZIPYeWQSzymAv5qa--
