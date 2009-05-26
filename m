From: Miles Lane <miles.lane@gmail.com>
Subject: Re: 2.6.30=rc6=git6 -- ata_piix 0000:00:1f.2: DMA-API: device driver
	maps memory from kernel text or rodata [addr=c0fff000]
Date: Tue, 26 May 2009 10:00:32 -0400
Message-ID: <a44ae5cd0905260700x488f94a3i5f53f5137aff5b7@mail.gmail.com>
References: <a44ae5cd0905230731q4df31403nd54ff9e2c496c77a@mail.gmail.com>
	 <200905232223.35780.rjw@sisk.pl> <4A18FE80.30403@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:54203 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402AbZEZOAc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 May 2009 10:00:32 -0400
In-Reply-To: <4A18FE80.30403@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Robert Hancock <hancockrwd@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Tejun Heo <tj@kernel.org>, IDE/ATA development list <linux-ide@vger.kernel.org>

On Sun, May 24, 2009 at 4:00 AM, Robert Hancock <hancockrwd@gmail.com> =
wrote:
> Rafael J. Wysocki wrote:
>>
>> Adding CCs.
>>
>> On Saturday 23 May 2009, Miles Lane wrote:
>>>
>>> [ =A0865.788574] WARNING: at lib/dma-debug.c:576
>>> check_for_illegal_area+0xdb/0x105()
>>> [ =A0865.788585] Hardware name: 1000HE
>>> [ =A0865.788596] ata_piix 0000:00:1f.2: DMA-API: device driver maps
>>> memory from kernel text or rodata [addr=3Dc0fff000] [size=3D4096]
>>> [ =A0865.788607] Modules linked in: sco bnep rfcomm l2cap pci_slot
>>> snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep
>>> snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss
>>> snd_seq_midi_event btusb snd_seq bluetooth snd_timer snd_seq_device
>>> ath9k snd soundcore snd_page_alloc atl1e
>>> [ =A0865.788718] Pid: 1559, comm: mount.ntfs Not tainted 2.6.30-rc6=
-git6 #2
>>> [ =A0865.788727] Call Trace:
>>> [ =A0865.788745] =A0[<c10206f4>] warn_slowpath_common+0x65/0x7c
>>> [ =A0865.788761] =A0[<c11666e2>] ? check_for_illegal_area+0xdb/0x10=
5
>>> [ =A0865.788777] =A0[<c102073f>] warn_slowpath_fmt+0x24/0x27
>>> [ =A0865.788793] =A0[<c11666e2>] check_for_illegal_area+0xdb/0x105
>>> [ =A0865.788811] =A0[<c1167629>] debug_dma_map_sg+0x10f/0x11b
>>> [ =A0865.788829] =A0[<c121347e>] ata_qc_issue+0x1b0/0x233
>>> [ =A0865.788848] =A0[<c1218cf0>] __ata_scsi_queuecmd+0x15a/0x1a7
>>> [ =A0865.788864] =A0[<c11fde34>] ? scsi_done+0x0/0xd
>>> [ =A0865.788879] =A0[<c12187d4>] ? ata_scsi_rw_xlat+0x0/0x1e9
>>> [ =A0865.788895] =A0[<c1218dbe>] ata_scsi_queuecmd+0x45/0x73
>>> [ =A0865.788909] =A0[<c11fde34>] ? scsi_done+0x0/0xd
>>> [ =A0865.788925] =A0[<c11fdf6e>] scsi_dispatch_cmd+0x12d/0x165
>>> [ =A0865.788941] =A0[<c1202253>] scsi_request_fn+0x299/0x3ca
>>> [ =A0865.788956] =A0[<c10282bf>] ? del_timer+0x47/0x4e
>>> [ =A0865.788974] =A0[<c11505b8>] __generic_unplug_device+0x26/0x29
>>> [ =A0865.788990] =A0[<c11505ff>] generic_unplug_device+0x21/0x2f
>>> [ =A0865.789006] =A0[<c11516c6>] blk_unplug+0x16/0x19
>>> [ =A0865.789021] =A0[<c11516d4>] blk_backing_dev_unplug+0xb/0xd
>>> [ =A0865.789038] =A0[<c10a57cf>] block_sync_page+0x24/0x28
>>> [ =A0865.789053] =A0[<c1069728>] sync_page+0x38/0x41
>>> [ =A0865.789068] =A0[<c106973a>] sync_page_killable+0x9/0x37
>>> [ =A0865.789085] =A0[<c13ab475>] __wait_on_bit_lock+0x34/0x6f
>>> [ =A0865.789099] =A0[<c1069731>] ? sync_page_killable+0x0/0x37
>>> [ =A0865.789115] =A0[<c1069613>] __lock_page_killable+0x71/0x78
>>> [ =A0865.789132] =A0[<c1030d9f>] ? wake_bit_function+0x0/0x37
>>> [ =A0865.789147] =A0[<c1069642>] lock_page_killable+0x28/0x2b
>>> [ =A0865.789162] =A0[<c106ad22>] generic_file_aio_read+0x315/0x493
>>> [ =A0865.789183] =A0[<c108c36c>] do_sync_read+0xaa/0xe5
>>> [ =A0865.789199] =A0[<c113181d>] ? file_has_perm+0x87/0xa1
>>> [ =A0865.789216] =A0[<c1030d70>] ? autoremove_wake_function+0x0/0x2=
f
>>> [ =A0865.789234] =A0[<c112e180>] ? security_file_permission+0xf/0x1=
1
>>> [ =A0865.789250] =A0[<c108c43c>] ? rw_verify_area+0x95/0xb6
>>> [ =A0865.789265] =A0[<c108c2c2>] ? do_sync_read+0x0/0xe5
>>> [ =A0865.789280] =A0[<c108ca03>] vfs_read+0x8d/0xea
>>> [ =A0865.789296] =A0[<c108cab3>] sys_pread64+0x53/0x6b
>>> [ =A0865.789313] =A0[<c1002c34>] syscall_call+0x7/0xb
>>> [ =A0865.789325] ---[ end trace 1ec3ba9a74f5a8d5 ]---
>
> Well, this seems to tell us that somebody's apparently doing SCSI rea=
ds or
> writes using kernel addresses. Unfortunately it doesn't really tell u=
s where
> this request came from. The stack trace occurred inside the mount.ntf=
s
> process.. could FUSE be doing something bad?
>
> Was anything strange happening on the machine when this showed up?
>

I have just hit this again with a build of 2.6.30-rc7.  I did not do
anything "unusual", but it might be helpful to know that this is
Ubuntu 9.10 (development) running with WUBI.  WUBI uses a file mounted
via loopback from an NTFS partition.  This file is ~10GB and contains
EXT3 root filesystem.

Any debugging suggestions?

Miles
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
