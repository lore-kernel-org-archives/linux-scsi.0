From: Adam Talbot <ajtalbot1@gmail.com>
Subject: Re: [Bug 81861] Oops by mvsas v0.8.16: sas: ataX: end_device-Y:0:Z:
 dev error handler -> general protection fault, RIP: mvs_task_prep_ata+0x80/0x3a0
Date: Wed, 29 Apr 2015 11:07:30 -0700
Message-ID: <CAH_2GheihL3WE75FrDigEdPzKRK6Up=rvoU10Y2rDMfp0_2q=g@mail.gmail.com>
References: <bug-81861-11613@https.bugzilla.kernel.org/>
	<bug-81861-11613-zXvwHJt3aC@https.bugzilla.kernel.org/>
	<1430317204.2189.2.camel@HansenPartnership.com>
	<CAC2CY-2YAy8GfjCHO+PrFWAuBnhfnMvK33KJ3YCVRZXJMEHykQ@mail.gmail.com>
	<1430322102.2189.14.camel@HansenPartnership.com>
	<CAH_2GhcOwjQqD0VYqMiD9UGRsYf4L-XRPaMHwPiRR1c2-PSQ7A@mail.gmail.com>
	<1430330700.2189.17.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:33052 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933267AbbD2SHb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Apr 2015 14:07:31 -0400
Received: by wief7 with SMTP id f7so46098082wie.0
        for <linux-scsi@vger.kernel.org>; Wed, 29 Apr 2015 11:07:30 -0700 (PDT)
In-Reply-To: <1430330700.2189.17.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Nathan Rennie-Waldock <nathan.renniewaldock@gmail.com>, linux-scsi <linux-scsi@vger.kernel.org>

My system was oopsing, pre patch.  I am happy to give you the full
configuration. Would that help?

On Wed, Apr 29, 2015 at 11:05 AM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Wed, 2015-04-29 at 09:24 -0700, Adam Talbot wrote:
>> Attached is what I see on my 4.0.0 patched kernel.  I am going through
>> a SAS expander:
>> [    5.176095] scsi host4: mvsas
>> [    5.180076] sas: phy-4:0 added to port-4:0, phy_mask:0x1 (50030480002f51ff)
>> [    5.180079] drivers/scsi/mvsas/mv_sas.c 1118:set wide port phy map 1
>> [    5.190007] sas: phy1 matched wide port0
>> [    5.190010] sas: phy-4:1 added to port-4:0, phy_mask:0x3 (50030480002f51ff)
>> [    5.190012] drivers/scsi/mvsas/mv_sas.c 1118:set wide port phy map 3
>> [    5.209850] sas: phy2 matched wide port0
>> [    5.209853] sas: phy-4:2 added to port-4:0, phy_mask:0x7 (50030480002f51ff)
>> [    5.209854] drivers/scsi/mvsas/mv_sas.c 1118:set wide port phy map 7
>> [    5.239609] sas: phy3 matched wide port0
>> [    5.239612] sas: phy-4:3 added to port-4:0, phy_mask:0xf (50030480002f51ff)
>> [    5.239613] drivers/scsi/mvsas/mv_sas.c 1118:set wide port phy map f
>> [    5.279368] sas: DOING DISCOVERY on port 0, pid:6
>> [    5.280102] sas: ex 50030480002f51ff phy00:S:9 attached:
>> 5005043011ab0000 (host)
>> [    5.280356] sas: ex 50030480002f51ff phy01:S:9 attached:
>> 5005043011ab0000 (host)
>> [    5.280622] sas: ex 50030480002f51ff phy02:S:9 attached:
>> 5005043011ab0000 (host)
>> [    5.280877] sas: ex 50030480002f51ff phy03:S:9 attached:
>> 5005043011ab0000 (host)
>> [    5.281141] sas: ex 50030480002f51ff phy04:D:9 attached:
>> 50030480002f51c4 (stp)
>> [    5.281339] sas: ex 50030480002f51ff phy05:D:9 attached:
>> 50030480002f51c5 (stp)
>> [    5.281547] sas: ex 50030480002f51ff phy06:D:9 attached:
>> 50030480002f51c6 (stp)
>> [    5.281801] sas: ex 50030480002f51ff phy07:D:9 attached:
>> 50030480002f51c7 (stp)
>> [    5.282003] sas: ex 50030480002f51ff phy08:D:9 attached:
>> 50030480002f51c8 (stp)
>> [    5.282216] sas: ex 50030480002f51ff phy09:D:8 attached:
>> 50030480002f51c9 (stp)
>> [    5.282419] sas: ex 50030480002f51ff phy10:D:8 attached:
>> 50030480002f51ca (stp)
>> [    5.282636] sas: ex 50030480002f51ff phy11:D:8 attached:
>> 50030480002f51cb (stp)
>> [    5.282862] sas: ex 50030480002f51ff phy12:D:8 attached:
>> 50030480002f51cc (stp)
>> [    5.283042] sas: ex 50030480002f51ff phy13:D:9 attached:
>> 50030480002f51cd (stp)
>> [    5.283202] sas: ex 50030480002f51ff phy14:D:8 attached:
>> 50030480002f51ce (stp)
>> [    5.283355] sas: ex 50030480002f51ff phy15:D:0 attached:
>> 0000000000000000 (no device)
>> [    5.283504] sas: ex 50030480002f51ff phy16:D:0 attached:
>> 0000000000000000 (no device)
>> [    5.283655] sas: ex 50030480002f51ff phy17:D:0 attached:
>> 0000000000000000 (no device)
>> [    5.283808] sas: ex 50030480002f51ff phy18:D:0 attached:
>> 0000000000000000 (no device)
>> [    5.283957] sas: ex 50030480002f51ff phy19:D:0 attached:
>> 0000000000000000 (no device)
>> [    5.284084] sas: ex 50030480002f51ff phy20:T:0 attached:
>> 0000000000000000 (no device)
>> [    5.284235] sas: ex 50030480002f51ff phy21:T:0 attached:
>> 0000000000000000 (no device)
>> [    5.284385] sas: ex 50030480002f51ff phy22:T:0 attached:
>> 0000000000000000 (no device)
>> [    5.284508] sas: ex 50030480002f51ff phy23:T:0 attached:
>> 0000000000000000 (no device)
>> [    5.284659] sas: ex 50030480002f51ff phy24:T:0 attached:
>> 0000000000000000 (no device)
>> [    5.284787] sas: ex 50030480002f51ff phy25:T:0 attached:
>> 0000000000000000 (no device)
>> [    5.284938] sas: ex 50030480002f51ff phy26:T:0 attached:
>> 0000000000000000 (no device)
>> [    5.285091] sas: ex 50030480002f51ff phy27:T:0 attached:
>> 0000000000000000 (no device)
>> [    5.285220] sas: ex 50030480002f51ff phy28:D:9 attached:
>> 50030480002f51fd (host+target)
>> [    5.285346] sas: ex 50030480002f51ff phy29:D:0 attached:
>> 0000000000000000 (no device)
>> [    5.286367] sas: DONE DISCOVERY on port 0, pid:6, result:0
>> [    5.286426] sas: Enter sas_scsi_recover_host busy: 0 failed: 0
>> [    5.286438] sas: ata5: end_device-4:0:4: dev error handler
>> [    5.286501] sas: ata6: end_device-4:0:5: dev error handler
>> [    5.286622] sas: ata7: end_device-4:0:6: dev error handler
>> [    5.286717] sas: ata8: end_device-4:0:7: dev error handler
>> [    5.286802] sas: ata9: end_device-4:0:8: dev error handler
>> [    5.286866] sas: ata10: end_device-4:0:9: dev error handler
>> [    5.286922] sas: ata11: end_device-4:0:10: dev error handler
>> [    5.287008] sas: ata12: end_device-4:0:11: dev error handler
>> [    5.287096] sas: ata13: end_device-4:0:12: dev error handler
>> [    5.287183] sas: ata14: end_device-4:0:13: dev error handler
>> [    5.287265] sas: ata15: end_device-4:0:14: dev error handler
>
> Right, but I actually need the configuration of the system that is
> currently oopsing.  Your trace seems to show a normal SATA discovery
> (the error handler shows up because a reset fis is part of SATA
> discovery).
>
> James
>
>
