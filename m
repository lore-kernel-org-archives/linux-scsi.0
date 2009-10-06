From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14333] New: config PCMCIA_AHA152X depends on !64BIT
Date: Tue, 6 Oct 2009 15:28:21 GMT
Message-ID: <bug-14333-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:47110 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757925AbZJFP25 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Oct 2009 11:28:57 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n96FSL57017978
	for <linux-scsi@vger.kernel.org>; Tue, 6 Oct 2009 15:28:21 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=3D14333

               URL: www.mygnu.de
           Summary: config PCMCIA_AHA152X depends on !64BIT
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 2.6.31
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: AHA152X
        AssignedTo: scsi_drivers-aha152x@kernel-bugs.osdl.org
        ReportedBy: mithrandir@loeb-it.de
        Regression: No


Building the driver for pcmcia aha152x cards is disabled for 64 Bit ker=
nels.
Searching for the reason for this I did not find anything. Then I built=
 the
driver removing the "depends on !64BIT" line in the config PCMCIA_AHA15=
2X
section in /usr/src/linux/drivers/scsi/pcmcia/Kconfig.

=46ull information on additional applied patches and full kconfig is av=
ailable on
http://www.mygnu.de/index.php/2009/10/zen-sources-2-6-31-r1-with-tuxoni=
ce/.

At least with my Adaptec SlimSCSI 1460 card it works without problems.

So I would be glad if the "no 64 Bits" dependency could be removed in f=
uture
kernels. Perhaps other drivers in the scsi-pcmcia section are also affe=
cted,
but I cannot try these out since the aha152.

best regards

J=C3=BCrgen

--=20
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=3Demail
------- You are receiving this mail because: -------
You are watching the assignee of the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
