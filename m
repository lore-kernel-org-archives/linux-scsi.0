Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AF79C43334
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Jul 2022 07:09:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231782AbiGOHJu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Jul 2022 03:09:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231514AbiGOHJX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Jul 2022 03:09:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABF567969A
        for <linux-scsi@vger.kernel.org>; Fri, 15 Jul 2022 00:08:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 33C78622F3
        for <linux-scsi@vger.kernel.org>; Fri, 15 Jul 2022 07:08:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 871CAC341C6
        for <linux-scsi@vger.kernel.org>; Fri, 15 Jul 2022 07:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657868909;
        bh=nuAEY6Efpx0qligEoEBi1llT7Jr97NGoHj8Gr3AA9KI=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=p3Trne5t9rG/fiWRAYoUI9QL4Pw2mTq5od+0zY4aUV7598ONFAYHh1csBs7UAeqnx
         TCkhmYQUGl7sLLFXBt+SGNm0gSDjj4xg41Lk8DeiHORGMU+N3+/3kdhbygdW6XkHpz
         BxN88+MCrC4lcY0Q1Y9N0nrL56nTa0e9ejkaZTz4ze11W5IRrWYRlSDO0yr021ULN2
         ZDKWCbRh0zX3EYKHdOjDkNktrc6bMixRneAd8JEaBSU6LadLldoNn67yI2Q0I2w7jJ
         RFAYQ5sXCKponXkq6U+8PKmXGZWDotYzPQL8OvLG0VJwYt3O7RqYaco2WFShAd9ckm
         vJqES0Q/OYmDw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 6D21DCC13B9; Fri, 15 Jul 2022 07:08:29 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 216232] mysterious block devices are shown under /dev folder
Date:   Fri, 15 Jul 2022 07:08:29 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-qla2xxx@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: QLOGIC QLA2XXX
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: yshxxsjt715@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-qla2xxx@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216232-11613-UK9uR0pRdp@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216232-11613@https.bugzilla.kernel.org/>
References: <bug-216232-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216232

--- Comment #2 from jshen28 (yshxxsjt715@gmail.com) ---
Hi, thank you very much for feedback,

the lsscsi output is quite long so I just pick a small part of it. I put
it in the attachment, please have a look. thank you.

Best,
Norman



On Wed, Jul 13, 2022 at 5:09 PM <bugzilla-daemon@kernel.org> wrote:

> https://bugzilla.kernel.org/show_bug.cgi?id=3D216232
>
> --- Comment #1 from Hannes Reinecke (hare@suse.de) ---
> On 7/10/22 11:47, bugzilla-daemon@kernel.org wrote:
> > https://bugzilla.kernel.org/show_bug.cgi?id=3D216232
> >
> >              Bug ID: 216232
> >             Summary: mysterious block devices are shown under /dev fold=
er
> >             Product: SCSI Drivers
> >             Version: 2.5
> >      Kernel Version: 5.4.61
> >            Hardware: All
> >                  OS: Linux
> >                Tree: Mainline
> >              Status: NEW
> >            Severity: normal
> >            Priority: P1
> >           Component: QLOGIC QLA2XXX
> >            Assignee: scsi_drivers-qla2xxx@kernel-bugs.osdl.org
> >            Reporter: yshxxsjt715@gmail.com
> >          Regression: No
> >
> > we are using linux kernel 5.4.61 and fibre channel card is qlogic's
> > ISP2722-based 16/32Gb adapter card.
> >
> > the problem is that we are seeing some devices with lun 768 with size of
> 512B
> > shown under /dev folder. In the syslog we saw something like
> >
> > Jul 10 17:00:08 hci01 kernel: [21675145.568997]
> scsi_io_completion_action: 24
> > callbacks suppressed
> > Jul 10 17:00:08 hci01 kernel: [21675145.569005] sd 6:0:0:768: [sdau]
> tag#1298
> > FAILED Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
> > Jul 10 17:00:08 hci01 kernel: [21675145.569011] sd 6:0:0:768: [sdau]
> tag#1298
> > Sense Key : Illegal Request [current]
> > Jul 10 17:00:08 hci01 kernel: [21675145.569015] sd 6:0:0:768: [sdau]
> tag#1298
> > Add. Sense: Logical block address out of range
> > Jul 10 17:00:08 hci01 kernel: [21675145.569019] sd 6:0:0:768: [sdau]
> tag#1298
> > CDB: Read(10) 28 00 00 00 00 00 00 00 01 00
> > Jul 10 17:00:08 hci01 kernel: [21675145.569021] print_req_error: 24
> callbacks
> > suppressed
> > Jul 10 17:00:08 hci01 kernel: [21675145.569025] blk_update_request:
> critical
> > target error, dev sdau, sector 0 op 0x0:(READ) flags 0x80700 phys_seg 1
> prio
> > class 0
> > Jul 10 17:00:08 hci01 kernel: [21675145.601879] sd 6:0:0:768: [sdau]
> tag#1299
> > FAILED Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
> > Jul 10 17:00:08 hci01 kernel: [21675145.601883] sd 6:0:0:768: [sdau]
> tag#1299
> > Sense Key : Illegal Request [current]
> > Jul 10 17:00:08 hci01 kernel: [21675145.601886] sd 6:0:0:768: [sdau]
> tag#1299
> > Add. Sense: Logical block address out of range
> > Jul 10 17:00:08 hci01 kernel: [21675145.601888] sd 6:0:0:768: [sdau]
> tag#1299
> > CDB: Read(10) 28 00 00 00 00 00 00 00 01 00
> > Jul 10 17:00:08 hci01 kernel: [21675145.601891] blk_update_request:
> critical
> > target error, dev sdau, sector 0 op 0x0:(READ) flags 0x0 phys_seg 1 prio
> > class
> > 0
> > Jul 10 17:00:08 hci01 kernel: [21675145.604213] buffer_io_error: 22
> callbacks
> > suppressed
> > Jul 10 17:00:08 hci01 kernel: [21675145.604215] Buffer I/O error on dev
> sdau,
> > logical block 0, async page read
> > Jul 10 17:00:08 hci01 kernel: [21675145.634149] sd 6:0:0:768: [sdau]
> tag#1300
> > FAILED Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
> > Jul 10 17:00:08 hci01 kernel: [21675145.634152] sd 6:0:0:768: [sdau]
> tag#1300
> > Sense Key : Illegal Request [current]
> > Jul 10 17:00:08 hci01 kernel: [21675145.634155] sd 6:0:0:768: [sdau]
> tag#1300
> > Add. Sense: Logical block address out of range
> > Jul 10 17:00:08 hci01 kernel: [21675145.634158] sd 6:0:0:768: [sdau]
> tag#1300
> > CDB: Read(10) 28 00 00 00 00 00 00 00 01 00
> >
> > here, the lun id of 768 does not exist on SAN but when I try to manually
> > delete
> > it, after some seconds it still appears.
> >
>
> This looks more like a configuration issue on the storage.
> What is the output of 'lsscsi' on your system?
>
> Cheers,
>
> Hannes
>
> --
> You may reply to this email to add a comment.
>
> You are receiving this mail because:
> You reported the bug.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
