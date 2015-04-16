From: Adam Talbot <ajtalbot1@gmail.com>
Subject: Re: mvsas panics and dies when attached to a port extender on newer kernels
Date: Thu, 16 Apr 2015 10:26:31 -0700
Message-ID: <CAH_2GhdsUqjmG4V-9X5QRkwNiVg9O5qp9Hpskis39qy=dmgYyA@mail.gmail.com>
References: <CAH_2Ghf565hKovkkccP_z6SO8v=7Ji=wdvL8YPnZNZ9WUUfGWg@mail.gmail.com>
	<1429046165.2209.54.camel@HansenPartnership.com>
	<CAH_2GhcsaDoxuxBwTT7cUsfp+5e_KjxtkJ4tFE1N05U=FCkJnA@mail.gmail.com>
	<1429161361.2608.4.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:32804 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752298AbbDPR0d (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Apr 2015 13:26:33 -0400
Received: by wiax7 with SMTP id x7so16656090wia.0
        for <linux-scsi@vger.kernel.org>; Thu, 16 Apr 2015 10:26:32 -0700 (PDT)
In-Reply-To: <1429161361.2608.4.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org

Wow, I forgot how long it takes to compile a full kernel.  Glad I ran
Gentoo for a few years and knew how to compile and apply patches. I
will admit I had to dust off some mental cobwebs.

Pre-patched 4.0.0 kernel tree: Oops, as expected
Patched 4.0.0 kernel tree: IT WORKED!!!!!  Basic mount, and checking a
few files all looks good.  I will start a RAID check as that should
really push the driver. I will report back tomorrow when it finishes.

Logs below.
[    5.072154] scsi host4: mvsas
[    5.180706] floppy0: no floppy controllers found
[    5.339613] ata12.00: ATA-8: ST32000542AS, CC35, max UDMA/133
[    5.339616] ata10.00: ATA-7: HDS725050KLA360, K2AOAD1A, max UDMA/133
[    5.339624] ata10.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    5.339892] ata11.00: ATA-7: HDS725050KLA360, K2AOAD1A, max UDMA/133
[    5.339893] ata11.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    5.340146] ata13.00: ATA-8: ST2000DL003-9VT166, CC32, max UDMA/133
[    5.340147] ata13.00: 3907029168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    5.341015] ata10.00: configured for UDMA/133
[    5.341344] ata11.00: configured for UDMA/133
[    5.341406] ata13.00: configured for UDMA/133
[    5.373207] ata5.00: ATA-8: WDC WD20EADS-11R6B1, 80.00A80, max UDMA/133
[    5.373208] ata5.00: 3907029168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    5.374223] ata8.00: ATA-8: WDC WD20EADS-42R6B0, 02.00A02, max UDMA/133
[    5.374224] ata8.00: 3907029168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    5.379766] ata5.00: configured for UDMA/133
[    5.380106] ata8.00: configured for UDMA/133
[    5.397396] ata7.00: ATA-8: WDC WD20EARS-00S8B1, 80.00A80, max UDMA/133
[    5.397396] ata7.00: 3907029168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    5.403539] ata7.00: configured for UDMA/133
[    5.451846] ata12.00: 3907029168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    5.460457] ata12.00: configured for UDMA/133
[    5.738535] ata6.00: ATA-8: WDC WD20EADS-11R6B1, 80.00A80, max UDMA/133
[    5.745214] ata6.00: 3907029168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    5.745267] ata9.00: ATA-8: WDC WD20EADS-42R6B0, 02.00A02, max UDMA/133
[    5.745268] ata9.00: 3907029168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    5.765626] ata9.00: configured for UDMA/133
[    5.771347] ata6.00: configured for UDMA/133
[    5.784708] scsi 4:0:0:0: Direct-Access     ATA      WDC
WD20EADS-11R 0A80 PQ: 0 ANSI: 5
[    5.793137] scsi 4:0:1:0: Direct-Access     ATA      WDC
WD20EADS-11R 0A80 PQ: 0 ANSI: 5
[    5.801560] scsi 4:0:2:0: Direct-Access     ATA      WDC
WD20EARS-00S 0A80 PQ: 0 ANSI: 5
[    5.809982] scsi 4:0:3:0: Direct-Access     ATA      WDC
WD20EADS-42R 0A02 PQ: 0 ANSI: 5
[    5.818404] scsi 4:0:4:0: Direct-Access     ATA      WDC
WD20EADS-42R 0A02 PQ: 0 ANSI: 5
[    5.826816] scsi 4:0:5:0: Direct-Access     ATA
HDS725050KLA360  AD1A PQ: 0 ANSI: 5
[    5.835171] scsi 4:0:6:0: Direct-Access     ATA
HDS725050KLA360  AD1A PQ: 0 ANSI: 5
[    5.843526] scsi 4:0:7:0: Direct-Access     ATA      ST32000542AS
  CC35 PQ: 0 ANSI: 5
[    5.851928] scsi 4:0:8:0: Direct-Access     ATA
ST2000DL003-9VT1 CC32 PQ: 0 ANSI: 5
[    5.862669] scsi 4:0:9:0: Enclosure         LSILOGIC SASX28 A.1
  7014 PQ: 0 ANSI: 3
[    6.140482] scsi 5:0:0:0: Direct-Access     Generic  USB EDC
  1.00 PQ: 0 ANSI: 2
[    6.148955] sd 5:0:0:0: Attached scsi generic sg2 type 0
[    6.149610] sd 5:0:0:0: [sdc] 2007040 512-byte logical blocks:
(1.02 GB/980 MiB)
[    6.150218] sd 5:0:0:0: [sdc] Write Protect is off
[    6.150840] sd 5:0:0:0: [sdc] No Caching mode page found
[    6.150841] sd 5:0:0:0: [sdc] Assuming drive cache: write through
[    6.153552]  sdc: sdc1
[    6.156225] sd 5:0:0:0: [sdc] Attached SCSI disk
[    6.185605] sd 4:0:0:0: [sdd] 3907029168 512-byte logical blocks:
(2.00 TB/1.81 TiB)
[    6.185633] sd 4:0:0:0: Attached scsi generic sg3 type 0
[    6.185799] sd 4:0:1:0: Attached scsi generic sg4 type 0
[    6.185801] sd 4:0:1:0: [sde] 3907029168 512-byte logical blocks:
(2.00 TB/1.81 TiB)
[    6.185802] sd 4:0:1:0: [sde] 4096-byte physical blocks
[    6.185837] sd 4:0:1:0: [sde] Write Protect is off
[    6.185848] sd 4:0:1:0: [sde] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    6.185978] sd 4:0:2:0: [sdf] 3907029168 512-byte logical blocks:
(2.00 TB/1.81 TiB)
[    6.185986] sd 4:0:2:0: Attached scsi generic sg5 type 0
[    6.186059] sd 4:0:2:0: [sdf] Write Protect is off
[    6.186148] sd 4:0:3:0: [sdg] 3907029168 512-byte logical blocks:
(2.00 TB/1.81 TiB)
[    6.186149] sd 4:0:2:0: [sdf] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    6.186163] sd 4:0:3:0: Attached scsi generic sg6 type 0
[    6.186188]  sde: sde1
[    6.186205] sd 4:0:3:0: [sdg] Write Protect is off
[    6.186234] sd 4:0:3:0: [sdg] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    6.186395] sd 4:0:4:0: [sdh] 3907029168 512-byte logical blocks:
(2.00 TB/1.81 TiB)
[    6.186417] sd 4:0:1:0: [sde] Attached SCSI disk
[    6.186439] sd 4:0:4:0: [sdh] Write Protect is off
[    6.186441] sd 4:0:4:0: Attached scsi generic sg7 type 0
[    6.186461] sd 4:0:4:0: [sdh] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    6.186628] sd 4:0:5:0: [sdi] 976773168 512-byte logical blocks:
(500 GB/465 GiB)
[    6.186670] sd 4:0:5:0: Attached scsi generic sg8 type 0
[    6.186685]  sdf: sdf1
[    6.186696]  sdg: sdg1
[    6.186726] sd 4:0:5:0: [sdi] Write Protect is off
[    6.186877]  sdh: sdh1
[    6.186882] sd 4:0:6:0: [sdj] 976773168 512-byte logical blocks:
(500 GB/465 GiB)
[    6.186905] sd 4:0:2:0: [sdf] Attached SCSI disk
[    6.186911] sd 4:0:6:0: Attached scsi generic sg9 type 0
[    6.186925] sd 4:0:5:0: [sdi] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    6.186945] sd 4:0:3:0: [sdg] Attached SCSI disk
[    6.186948] sd 4:0:6:0: [sdj] Write Protect is off
[    6.186977] sd 4:0:6:0: [sdj] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    6.187142] sd 4:0:4:0: [sdh] Attached SCSI disk
[    6.187171] sd 4:0:7:0: [sdk] 3907029168 512-byte logical blocks:
(2.00 TB/1.81 TiB)
[    6.187198] sd 4:0:7:0: Attached scsi generic sg10 type 0
[    6.187240] sd 4:0:7:0: [sdk] Write Protect is off
[    6.187266] sd 4:0:7:0: [sdk] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    6.187355] sd 4:0:8:0: [sdl] 3907029168 512-byte logical blocks:
(2.00 TB/1.81 TiB)
[    6.187377] sd 4:0:8:0: [sdl] Write Protect is off
[    6.187394] sd 4:0:8:0: [sdl] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    6.187400] sd 4:0:8:0: Attached scsi generic sg11 type 0
[    6.187589] scsi 4:0:9:0: Attached scsi generic sg12 type 13
[    6.200457]  sdl: sdl1
[    6.200601] sd 4:0:8:0: [sdl] Attached SCSI disk
[    6.202898]  sdi: sdi1
[    6.203316] sd 4:0:5:0: [sdi] Attached SCSI disk
[    6.203662] random: nonblocking pool is initialized
[    6.203687]  sdj: sdj1
[    6.204047] sd 4:0:6:0: [sdj] Attached SCSI disk
[    6.207504]  sdk: sdk1
[    6.207764] sd 4:0:7:0: [sdk] Attached SCSI disk
[    6.488728] sd 4:0:0:0: [sdd] 4096-byte physical blocks
[    6.494046] sd 4:0:0:0: [sdd] Write Protect is off
[    6.498906] sd 4:0:0:0: [sdd] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    6.508482]  sdd: sdd1
[    6.511045] sd 4:0:0:0: [sdd] Attached SCSI disk
[    6.654475] md: bind<sdl1>
[    6.668281] md: bind<sdh1>
[    6.672779] md: bind<sdd1>
[    6.677573] md: bind<sdj1>
[    6.681852] md: bind<sdi1>
[    6.685906] md/raid1:md125: active with 2 out of 2 mirrors
[    6.686221] md: bind<sde1>
[    6.694288] md125: detected capacity change from 0 to 499972440064
[    6.697903] md: bind<sdk1>
[    6.707702] md: bind<sdg1>
[    6.789676] md: bind<sdf1>
[    6.864048] raid6: sse2x1    7299 MB/s
[    6.932065] raid6: sse2x2    8507 MB/s
[    7.000052] raid6: sse2x4    9334 MB/s
[    7.003883] raid6: using algorithm sse2x4 (9334 MB/s)
[    7.009030] raid6: using ssse3x2 recovery algorithm
[    7.016950] xor: measuring software checksum speed
[    7.060033]    prefetch64-sse: 12476.000 MB/sec
[    7.104097]    generic_sse: 11050.000 MB/sec
[    7.108414] xor: using function: prefetch64-sse (12476.000 MB/sec)
[    7.115066] async_tx: api initialized (async)
[    7.120852] md: raid6 personality registered for level 6
[    7.126224] md: raid5 personality registered for level 5
[    7.131583] md: raid4 personality registered for level 4
[    7.137118] md/raid:md126: device sdf1 operational as raid disk 2
[    7.143266] md/raid:md126: device sdg1 operational as raid disk 3
[    7.149407] md/raid:md126: device sdk1 operational as raid disk 6
[    7.155550] md/raid:md126: device sde1 operational as raid disk 1
[    7.161693] md/raid:md126: device sdd1 operational as raid disk 0
[    7.167836] md/raid:md126: device sdh1 operational as raid disk 4
[    7.173979] md/raid:md126: device sdl1 operational as raid disk 5
[    7.180538] md/raid:md126: allocated 0kB
[    7.184619] md/raid:md126: raid level 6 active with 7 out of 7
devices, algorithm 2

On Wed, Apr 15, 2015 at 10:16 PM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Tue, 2015-04-14 at 14:41 -0700, Adam Talbot wrote:
>> Removing the sas expander and attaching the SATA drives directly works
>> just fine. I had to limp along with the drives direct attached for a
>> while, while debugging.
>
> Well, that narrows it down.  It looks like there's a longstanding bug in
> mvs_task_prep_ata() where the physical PHY field is populated by taking
> an index through the HBA phy table.  This field is ignored for STP but
> the phy table is too small and it uses the expander phy number to index
> it (hence the GPF as we fall off the end of the phy table trying to
> dereference sas_phy->id).
>
> This should fix the problem.
>
> James
>
> ---
>
> diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
> index 2d5ab6d..454536c 100644
> --- a/drivers/scsi/mvsas/mv_sas.c
> +++ b/drivers/scsi/mvsas/mv_sas.c
> @@ -441,14 +441,11 @@ static u32 mvs_get_ncq_tag(struct sas_task *task, u32 *tag)
>  static int mvs_task_prep_ata(struct mvs_info *mvi,
>                              struct mvs_task_exec_info *tei)
>  {
> -       struct sas_ha_struct *sha = mvi->sas;
>         struct sas_task *task = tei->task;
>         struct domain_device *dev = task->dev;
>         struct mvs_device *mvi_dev = dev->lldd_dev;
>         struct mvs_cmd_hdr *hdr = tei->hdr;
>         struct asd_sas_port *sas_port = dev->port;
> -       struct sas_phy *sphy = dev->phy;
> -       struct asd_sas_phy *sas_phy = sha->sas_phy[sphy->number];
>         struct mvs_slot_info *slot;
>         void *buf_prd;
>         u32 tag = tei->tag, hdr_tag;
> @@ -468,7 +465,7 @@ static int mvs_task_prep_ata(struct mvs_info *mvi,
>         slot->tx = mvi->tx_prod;
>         del_q = TXQ_MODE_I | tag |
>                 (TXQ_CMD_STP << TXQ_CMD_SHIFT) |
> -               (MVS_PHY_ID << TXQ_PHY_SHIFT) |
> +               ((sas_port->phy_mask & TXQ_PHY_MASK) << TXQ_PHY_SHIFT) |
>                 (mvi_dev->taskfileset << TXQ_SRS_SHIFT);
>         mvi->tx[mvi->tx_prod] = cpu_to_le32(del_q);
>
>
>
>
>
