From: Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference at      
   (null)
Date: Wed, 20 Jul 2011 21:13:58 -0700
Message-ID: <20110720211358.7a6e5f4c.rdunlap@xenotime.net>
References: <4E26F069.60103@techboom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4E26F069.60103@techboom.com>
Sender: linux-kernel-owner@vger.kernel.org
To: TB <lkml@techboom.com>, scsi <linux-scsi@vger.kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 20 Jul 2011 11:12:41 -0400 TB wrote:

[adding linux-scsi mailing list]

> This is with kernel 2.6.39 compiled with
> gcc (Debian 4.3.2-1.1) 4.3.2
> 
> Please CC me as I am not subscribed to the mailing list.
> 
> [567683.945368] aacraid: SCSI bus appears hung
> [567778.804257] scsi_eh_0: page allocation failure. order: 6, mode:0x20
> [567778.804262] Pid: 962, comm: scsi_eh_0 Tainted: G   M   2.6.39 #1
> [567778.804265] Call Trace:
> [567778.804277]  [<ffffffff8108e285>] ? __alloc_pages_nodemask+0x74f/0x7b9
> [567778.804284]  [<ffffffff812f36b1>] ? __domain_mapping+0x181/0x1b7
> [567778.804289]  [<ffffffff8108d249>] ? __get_free_pages+0x9/0x46
> [567778.804293]  [<ffffffff812f3c78>] ? intel_alloc_coherent+0x83/0xdb
> [567778.804300]  [<ffffffff8137557d>] ? aac_fib_setup+0xf8/0x227
> [567778.804304]  [<ffffffff8137531d>] ? aac_init_adapter+0x7a9/0x7d7
> [567778.804309]  [<ffffffff81379bc3>] ? aac_src_init+0x26b/0x3bb
> [567778.804315]  [<ffffffff810bb4f6>] ? add_partial+0x11/0x57
> [567778.804319]  [<ffffffff8137653f>] ? _aac_reset_adapter+0x29e/0x473
> [567778.804326]  [<ffffffff81377592>] ? aac_reset_adapter+0x118/0x252
> [567778.804329]  [<ffffffff813702d1>] ? aac_eh_reset+0x15e/0x185
> [567778.804333]  [<ffffffff81358c85>] ? scsi_try_host_reset+0x51/0xcc
> [567778.804336]  [<ffffffff81359f84>] ? scsi_eh_ready_devs+0x671/0x7e6
> [567778.804339]  [<ffffffff8135a63c>] ? scsi_error_handler+0x39b/0x59d
> [567778.804342]  [<ffffffff8135a2a1>] ? scsi_eh_get_sense+0x1a8/0x1a8
> [567778.804347]  [<ffffffff8104d98a>] ? kthread+0x7e/0x86
> [567778.804351]  [<ffffffff8156d094>] ? kernel_thread_helper+0x4/0x10
> [567778.804354]  [<ffffffff8104d90c>] ? kthread_worker_fn+0x10d/0x10d
> [567778.804357]  [<ffffffff8156d090>] ? gs_change+0xb/0xb
> [567778.804358] Mem-Info:
> [567778.804359] Node 0 DMA per-cpu:
> [567778.804362] CPU    0: hi:    0, btch:   1 usd:   0
> [567778.804364] CPU    1: hi:    0, btch:   1 usd:   0
> [567778.804365] CPU    2: hi:    0, btch:   1 usd:   0
> [567778.804367] CPU    3: hi:    0, btch:   1 usd:   0
> [567778.804369] CPU    4: hi:    0, btch:   1 usd:   0
> [567778.804370] CPU    5: hi:    0, btch:   1 usd:   0
> [567778.804372] CPU    6: hi:    0, btch:   1 usd:   0
> [567778.804374] CPU    7: hi:    0, btch:   1 usd:   0
> [567778.804375] CPU    8: hi:    0, btch:   1 usd:   0
> [567778.804377] CPU    9: hi:    0, btch:   1 usd:   0
> [567778.804379] CPU   10: hi:    0, btch:   1 usd:   0
> [567778.804380] CPU   11: hi:    0, btch:   1 usd:   0
> [567778.804382] CPU   12: hi:    0, btch:   1 usd:   0
> [567778.804384] CPU   13: hi:    0, btch:   1 usd:   0
> [567778.804385] CPU   14: hi:    0, btch:   1 usd:   0
> [567778.804387] CPU   15: hi:    0, btch:   1 usd:   0
> [567778.804389] Node 0 DMA32 per-cpu:
> [567778.804391] CPU    0: hi:  186, btch:  31 usd: 149
> [567778.804392] CPU    1: hi:  186, btch:  31 usd:   0
> [567778.804394] CPU    2: hi:  186, btch:  31 usd:   0
> [567778.804396] CPU    3: hi:  186, btch:  31 usd:   0
> [567778.804398] CPU    4: hi:  186, btch:  31 usd:   0
> [567778.804399] CPU    5: hi:  186, btch:  31 usd:   0
> [567778.804401] CPU    6: hi:  186, btch:  31 usd:   0
> [567778.804403] CPU    7: hi:  186, btch:  31 usd:   0
> [567778.804404] CPU    8: hi:  186, btch:  31 usd:   0
> [567778.804406] CPU    9: hi:  186, btch:  31 usd:   0
> [567778.804408] CPU   10: hi:  186, btch:  31 usd: 167
> [567778.804410] CPU   11: hi:  186, btch:  31 usd:   0
> [567778.804411] CPU   12: hi:  186, btch:  31 usd:   0
> [567778.804413] CPU   13: hi:  186, btch:  31 usd:   0
> [567778.804414] CPU   14: hi:  186, btch:  31 usd:   0
> [567778.804416] CPU   15: hi:  186, btch:  31 usd:   0
> [567778.804417] Node 0 Normal per-cpu:
> [567778.804420] CPU    0: hi:  186, btch:  31 usd: 161
> [567778.804421] CPU    1: hi:  186, btch:  31 usd: 104
> [567778.804423] CPU    2: hi:  186, btch:  31 usd:  50
> [567778.804424] CPU    3: hi:  186, btch:  31 usd:   0
> [567778.804426] CPU    4: hi:  186, btch:  31 usd:   0
> [567778.804428] CPU    5: hi:  186, btch:  31 usd: 183
> [567778.804429] CPU    6: hi:  186, btch:  31 usd:   0
> [567778.804431] CPU    7: hi:  186, btch:  31 usd:   0
> [567778.804433] CPU    8: hi:  186, btch:  31 usd: 165
> [567778.804435] CPU    9: hi:  186, btch:  31 usd:  42
> [567778.804436] CPU   10: hi:  186, btch:  31 usd: 160
> [567778.804438] CPU   11: hi:  186, btch:  31 usd:   0
> [567778.804440] CPU   12: hi:  186, btch:  31 usd:   0
> [567778.804441] CPU   13: hi:  186, btch:  31 usd:   5
> [567778.804443] CPU   14: hi:  186, btch:  31 usd:   0
> [567778.804444] CPU   15: hi:  186, btch:  31 usd:   0
> [567778.804446] Node 1 Normal per-cpu:
> [567778.804448] CPU    0: hi:  186, btch:  31 usd: 185
> [567778.804450] CPU    1: hi:  186, btch:  31 usd: 166
> [567778.804451] CPU    2: hi:  186, btch:  31 usd:  68
> [567778.804453] CPU    3: hi:  186, btch:  31 usd:   1
> [567778.804455] CPU    4: hi:  186, btch:  31 usd: 119
> [567778.804456] CPU    5: hi:  186, btch:  31 usd:  22
> [567778.804458] CPU    6: hi:  186, btch:  31 usd:  27
> [567778.804460] CPU    7: hi:  186, btch:  31 usd:   0
> [567778.804461] CPU    8: hi:  186, btch:  31 usd: 176
> [567778.804463] CPU    9: hi:  186, btch:  31 usd:   5
> [567778.804465] CPU   10: hi:  186, btch:  31 usd: 133
> [567778.804466] CPU   11: hi:  186, btch:  31 usd:   0
> [567778.804468] CPU   12: hi:  186, btch:  31 usd: 151
> [567778.804470] CPU   13: hi:  186, btch:  31 usd: 185
> [567778.804471] CPU   14: hi:  186, btch:  31 usd:  82
> [567778.804473] CPU   15: hi:  186, btch:  31 usd:  34
> [567778.804477] active_anon:1207894 inactive_anon:127905 isolated_anon:0
> [567778.804478]  active_file:2522893 inactive_file:2504636 isolated_file:0
> [567778.804479]  unevictable:41 dirty:38 writeback:0 unstable:0
> [567778.804480]  free:1445271 slab_reclaimable:160878
> slab_unreclaimable:240267
> [567778.804481]  mapped:141123 shmem:1827 pagetables:21711 bounce:0
> [567778.804483] Node 0 DMA free:15880kB min:40kB low:48kB high:60kB
> active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB
> unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15656kB
> mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB
> slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB
> pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0
> all_unreclaimable? yes
> [567778.804493] lowmem_reserve[]: 0 2991 16121 16121
> [567778.804495] Node 0 DMA32 free:319744kB min:8344kB low:10428kB
> high:12516kB active_anon:389620kB inactive_anon:104492kB
> active_file:849196kB inactive_file:849504kB unevictable:12kB
> isolated(anon):0kB isolated(file):0kB present:3063520kB mlocked:12kB
> dirty:8kB writeback:0kB mapped:16272kB shmem:76kB
> slab_reclaimable:223936kB slab_unreclaimable:370680kB
> kernel_stack:1760kB pagetables:516kB unstable:0kB bounce:0kB
> writeback_tmp:0kB pages_scanned:245 all_unreclaimable? no
> [567778.804506] lowmem_reserve[]: 0 0 13130 13130
> [567778.804509] Node 0 Normal free:3333768kB min:36632kB low:45788kB
> high:54948kB active_anon:2179952kB inactive_anon:218320kB
> active_file:3476976kB inactive_file:3453700kB unevictable:128kB
> isolated(anon):0kB isolated(file):0kB present:13445120kB mlocked:0kB
> dirty:92kB writeback:0kB mapped:53932kB shmem:6664kB
> slab_reclaimable:221760kB slab_unreclaimable:392212kB
> kernel_stack:1320kB pagetables:45812kB unstable:0kB bounce:0kB
> writeback_tmp:0kB pages_scanned:33 all_unreclaimable? no
> [567778.804519] lowmem_reserve[]: 0 0 0 0
> [567778.804522] Node 1 Normal free:2111692kB min:45088kB low:56360kB
> high:67632kB active_anon:2262004kB inactive_anon:188808kB
> active_file:5764876kB inactive_file:5715340kB unevictable:24kB
> isolated(anon):0kB isolated(file):0kB present:16547840kB mlocked:192kB
> dirty:52kB writeback:0kB mapped:494288kB shmem:568kB
> slab_reclaimable:197816kB slab_unreclaimable:198176kB kernel_stack:944kB
> pagetables:40516kB unstable:0kB bounce:0kB writeback_tmp:0kB
> pages_scanned:63 all_unreclaimable? no
> [567778.804532] lowmem_reserve[]: 0 0 0 0
> [567778.804535] Node 0 DMA: 0*4kB 1*8kB 0*16kB 0*32kB 2*64kB 1*128kB
> 1*256kB 0*512kB 1*1024kB 1*2048kB 3*4096kB = 15880kB
> [567778.804542] Node 0 DMA32: 9986*4kB 14264*8kB 9219*16kB 576*32kB
> 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 319992kB
> [567778.804548] Node 0 Normal: 458680*4kB 123961*8kB 31413*16kB 157*32kB
> 6*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 3334552kB
> [567778.804555] Node 1 Normal: 253413*4kB 79386*8kB 28562*16kB 226*32kB
> 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 2112964kB
> [567778.804562] 5031610 total pagecache pages
> [567778.804563] 2624 pages in swap cache
> [567778.804565] Swap cache stats: add 34221223, delete 34218599, find
> 16354807/21177156
> [567778.804567] Free swap  = 7401220kB
> [567778.804568] Total swap = 7999416kB
> [567778.932784] 8388592 pages RAM
> [567778.932786] 119955 pages reserved
> [567778.932787] 3233713 pages shared
> [567778.932788] 4446427 pages non-shared
> [567798.905490] aacraid: Host adapter abort request (0,0,1,0)
> [567808.890221] aacraid: Host adapter abort request (0,0,1,0)
> [567818.874952] aacraid: Host adapter abort request (0,0,0,0)
> [567828.859673] aacraid: Host adapter abort request (0,0,0,0)
> [567828.859728] aacraid: Host adapter reset request. SCSI hang ?
> [567889.007644] aacraid: SCSI bus appears hung
> [567889.007693] BUG: unable to handle kernel NULL pointer dereference at
>           (null)
> [567889.007777] IP: [<ffffffff81052adc>] exit_creds+0x12/0x78
> [567889.007830] PGD 0
> [567889.007866] Oops: 0000 [#1] SMP
> [567889.007907] last sysfs file:
> /sys/devices/pci0000:00/0000:00:1f.2/host2/target2:0:0/2:0:0:0/vendor
> [567889.007986] CPU 14
> [567889.007995] Modules linked in: i2c_i801 evdev i2c_core button [last
> unloaded: scsi_wait_scan]
> [567889.008112]
> [567889.008144] Pid: 962, comm: scsi_eh_0 Tainted: G   M        2.6.39
> #1 Supermicro X8DTH-i/6/iF/6F/X8DTH
> [567889.008233] RIP: 0010:[<ffffffff81052adc>]  [<ffffffff81052adc>]
> exit_creds+0x12/0x78
> [567889.008311] RSP: 0018:ffff88042eab5b80  EFLAGS: 00010206
> [567889.008355] RAX: 0000000000000000 RBX: ffff88042f93e540 RCX:
> 00000000001225c9
> [567889.008427] RDX: 00000000000003c3 RSI: 0000000000000002 RDI:
> 0000000000000000
> [567889.008499] RBP: ffff88042f93e540 R08: 00000000001225c9 R09:
> 000000000000000a
> [567889.008572] R10: 0000000000000000 R11: ffff88042eab5b00 R12:
> 0000000000000000
> [567889.008644] R13: ffff88083e1f9450 R14: ffff88083e1f9000 R15:
> ffff88083e1f9000
> [567889.008716] FS:  0000000000000000(0000) GS:ffff88083fcc0000(0000)
> knlGS:0000000000000000
> [567889.008792] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [567889.008836] CR2: 0000000000000000 CR3: 0000000001781000 CR4:
> 00000000000006e0
> [567889.008909] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> 0000000000000000
> [567889.008981] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
> 0000000000000400
> [567889.009054] Process scsi_eh_0 (pid: 962, threadinfo
> ffff88042eab4000, task ffff88042f93dfa0)
> [567889.009130] Stack:
> [567889.009162]  ffff88042f93e540 ffffffff81034890 ffff88042f93e550
> ffffffff8104db08
> [567889.009245]  0000000000000282 0000000000000002 ffff88083e1f9450
> ffffffff81376306
> [567889.009327]  ffff880197e6ba00 0000000000000000 000000000000000e
> 0000000000000282
> [567889.009409] Call Trace:
> [567889.009448]  [<ffffffff81034890>] ? __put_task_struct+0x5d/0x83
> [567889.009496]  [<ffffffff8104db08>] ? kthread_stop+0x7a/0xaa
> [567889.009544]  [<ffffffff81376306>] ? _aac_reset_adapter+0x65/0x473
> [567889.009591]  [<ffffffff81377592>] ? aac_reset_adapter+0x118/0x252
> [567889.009638]  [<ffffffff813702d1>] ? aac_eh_reset+0x15e/0x185
> [567889.009685]  [<ffffffff81358c85>] ? scsi_try_host_reset+0x51/0xcc
> [567889.009732]  [<ffffffff813597cd>] ? scsi_send_eh_cmnd+0x225/0x28d
> [567889.009781]  [<ffffffff8104116c>] ? del_timer+0xb0/0xb0
> [567889.009825]  [<ffffffff8135985d>] ? scsi_eh_tur+0x28/0x78
> [567889.009869]  [<ffffffff81359fe3>] ? scsi_eh_ready_devs+0x6d0/0x7e6
> [567889.009916]  [<ffffffff8135a63c>] ? scsi_error_handler+0x39b/0x59d
> [567889.009963]  [<ffffffff8135a2a1>] ? scsi_eh_get_sense+0x1a8/0x1a8
> [567889.010009]  [<ffffffff8104d98a>] ? kthread+0x7e/0x86
> [567889.010055]  [<ffffffff8156d094>] ? kernel_thread_helper+0x4/0x10
> [567889.010102]  [<ffffffff8104d90c>] ? kthread_worker_fn+0x10d/0x10d
> [567889.010148]  [<ffffffff8156d090>] ? gs_change+0xb/0xb
> [567889.010190] Code: ff 4d 00 0f 94 c0 84 c0 74 08 48 89 ef e8 60 fd ff
> ff 31 c0 5b 5d 41 5c c3 53 48 89 fb 48 8b 87 e8 02 00 00 48 8b bf e0 02
> 00 00 <8b> 00 48 c7 83 e0 02 00 00 00 00 00 00 f0 ff 0f 0f 94 c0 84 c0
> [567889.010469] RIP  [<ffffffff81052adc>] exit_creds+0x12/0x78
> [567889.010516]  RSP <ffff88042eab5b80>
> [567889.010553] CR2: 0000000000000000
> [567889.010945] ---[ end trace e8209ec333f4963e ]---
> --


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
