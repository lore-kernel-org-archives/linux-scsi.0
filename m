Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81DEFC19F2D
	for <linux-scsi@archiver.kernel.org>; Sat,  6 Aug 2022 13:50:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231259AbiHFNub (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 6 Aug 2022 09:50:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230018AbiHFNu1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 6 Aug 2022 09:50:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33EADDF63
        for <linux-scsi@vger.kernel.org>; Sat,  6 Aug 2022 06:50:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B5B8DB8068F
        for <linux-scsi@vger.kernel.org>; Sat,  6 Aug 2022 13:50:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7D8E4C43470
        for <linux-scsi@vger.kernel.org>; Sat,  6 Aug 2022 13:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659793820;
        bh=SmXSTyG6jDa8VoXsQ4txHIRbPfK066v2mo5ZRsjb5Rs=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=aRKj7qfi+dKi3CwVn/GF/vOhFxAE28ooWS4x2zpX3vsiX/4tDvCO9JCMcuwKfq9S4
         mEXo5XUzIGfEM5rJVD+2nuMwZtu8195P4N5+no4WJUv7ivAPFFjeH0ZCihWRrUDQef
         BMhslNr4GEuImuZJeTlgD5q9H1FUQD77j/OB1UXLt3ZVk+89USbeNb78BFv66WUVkC
         gYPZjujuGvyJ+VnLUmsHpK566bmDjB+hgu448m2bfwYRs3UgW7Lq4MPX5YojRKjea1
         okgBqyEpEFe74Cacn+/eUyiauyEa3EZ4hyD68sZsMvTntCNJFSUzBD8uc+q7SV+XKH
         tlW56icOOXzqQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 68E96C0422F; Sat,  6 Aug 2022 13:50:20 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 198975] Highpoint 840A RocketRAID Controller and drives are NOT
 detected by SCSI_HPTIOP kernel module
Date:   Sat, 06 Aug 2022 13:50:19 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: allhddcoumputer@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-198975-11613-IzDwNoo27c@https.bugzilla.kernel.org/>
In-Reply-To: <bug-198975-11613@https.bugzilla.kernel.org/>
References: <bug-198975-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D198975

Jaym12 (allhddcoumputer@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |allhddcoumputer@gmail.com

--- Comment #7 from Jaym12 (allhddcoumputer@gmail.com) ---
I fixed this error(In reply to Matthias Lippert from comment #0)
> Hello,
>=20
> This is my first kernel bugzilla report, so please have mercy ;-)
>=20
> My freshly bought Highpoint 840A RocketRAID Controller and its 8 connected
> "Samsung 860 EVO" ssd harddrives are NOT detected by the "SCSI_HPTIOP"
> kernel low-level scsi driver module, but it seems to be the smaller broth=
er
> of the already from kernel supported 3740A RocketRAID controller by
> Highpoint.
> The only differnence seems to be that the 840A supports only 6Gb/s per
> channel.
> Thats is also confirmed by the top down view onto the expansion card.
> In the upper right corner you can see the described dual product markings
> "RocketRAID 3740A/840A", so the layout and most likely also the raid
> processor of the controller has been used at least twice by Highpoint.
> My controllers firmware is the recent 1.0.0 version.
> I couldnt find any other driver module that is matching my controller more
> closely.
> The current published linux drivers by highpoint are useless under (Gento=
o)
> Linux.
> The controller and its connected drives are working flawlessy under Windo=
ws
> 10, so its not damaged. I am using a "Gigabyte X99-SLI" motherboard with
> recent F24a bios version.
> I am also willingly able to provide regular dump logs to kernel developers
> for driver debugging.
>=20
> I would be VERY thankful for including support into the next kernel for t=
his
> cool piece of hardware!
>=20
>=20
> Top-down view onto the expansion card:
>=20
> https://www.bhphotovideo.com/images/images1000x1000/
> highpoint_rocketraid_3740a_12gb_s_pcie_1269779.jpg
>=20
>=20
> dmesg outputs only this, then nothing else related to my controller:
>=20
> RocketRAID 3xxx/4xxx Controller driver v1.10.0
>=20
>=20
> lspci -kvv outputs this:
>=20
> 02:00.0 RAID bus controller: HighPoint Technologies, Inc. Device 0840 (rev
> a1)
>         Subsystem: HighPoint Technologies, Inc. Device 0000
>         Physical Slot: 6
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParEr=
r-
> Stepping- SERR+ FastB2B- DisINTx-
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0, Cache Line Size: 32 bytes
>         Interrupt: pin A routed to IRQ 11
>         NUMA node: 0
>         Region 0: Memory at d0900000 (64-bit, prefetchable) [size=3D1M]
>         Region 4: Memory at d0a00000 (64-bit, prefetchable) [size=3D256K]
>         Expansion ROM at dfe00000 [disabled] [size=3D128K]
>         Capabilities: [80] Power Management version 3
>                 Flags: PMEClk- DSI- D1+ D2- AuxCurrent=3D0mA
> PME(D0+,D1+,D2-,D3hot+,D3cold-)
>                 Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
>         Capabilities: [90] MSI: Enable- Count=3D1/32 Maskable+ 64bit+
>                 Address: 0000000000000000  Data: 0000
>                 Masking: 00000000  Pending: 00000000
>         Capabilities: [b0] MSI-X: Enable- Count=3D18 Masked-
>                 Vector table: BAR=3D0 offset=3D00038000
>                 PBA: BAR=3D0 offset=3D00039000
>         Capabilities: [c0] Express (v2) Endpoint, MSI 00
>                 DevCap: MaxPayload 512 bytes, PhantFunc 0, Latency L0s
> <128ns, L1 <2us
>                         ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
> SlotPowerLimit 0.000W
>                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
> Unsupported-
>                         RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
>                         MaxPayload 256 bytes, MaxReadReq 512 bytes
>                 DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr-
> TransPend-
>                 LnkCap: Port #0, Speed 8GT/s, Width x8, ASPM L0s L1, Exit
> Latency L0s <128ns, L1 <2us
>                         ClockPM- Surprise- LLActRep- BwNot- ASPMOptComp+
>                 LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk-
>                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>                 LnkSta: Speed 8GT/s, Width x8, TrErr- Train- SlotClk-
> DLActive- BWMgmt- ABWMgmt-
>                 DevCap2: Completion Timeout: Range B, TimeoutDis+, LTR-,
> OBFF Not Supported
>                 DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-,
> LTR-, OBFF Disabled
>                 LnkCtl2: Target Link Speed: 8GT/s, EnterCompliance- Speed=
Dis-
>                          Transmit Margin: Normal Operating Range,
> EnterModifiedCompliance- ComplianceSOS-
>                          Compliance De-emphasis: -6dB
>                 LnkSta2: Current De-emphasis Level: -6dB,
> EqualizationComplete+, EqualizationPhase1+
>                          EqualizationPhase2+, EqualizationPhase3+,
> LinkEqualizationRequest-
>         Capabilities: [100 v2] Advanced Error Reporting
>                 UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
> RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
>                 UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
> RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
>                 UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt-
> RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
>                 CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout-
> NonFatalErr-
>                 CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout-
> NonFatalErr+
>                 AERCap: First Error Pointer: 00, GenCap+ CGenEn- ChkCap+
> ChkEn-
>         Capabilities: [300 v1] #19
>=20
>=20
> Highpoints 800er series RocketRAID website:
>=20
> http://www.highpoint-tech.com/USA_new/series-rr800-overview.htm
>=20
>=20
> Highpoints 3700er series RocketRAID website:
>=20
http://www.highpoint-tech.com/USA_new/series-rr3700-overview.htm

> I have been facing the same issue.
> https://www.allhdd.com/seagate-st3000lm024-sata-6gbps-hdd/

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
