From: Sebastian Voitzsch <sebastian.voitzsch@web.de>
Subject: trouble with initio-based controller / Nikon LS-2000
Date: Sat, 19 Nov 2005 11:39:15 +0100
Message-ID: <200511191139.15304.sebastian.voitzsch@web.de>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_TDwfDyJ1Aal593g"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp05.web.de ([217.72.192.209]:63930 "EHLO smtp05.web.de")
	by vger.kernel.org with ESMTP id S1751065AbVKSKjS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 19 Nov 2005 05:39:18 -0500
Received: from [80.143.175.36] (helo=harry)
	by smtp05.web.de with asmtp (WEB.DE 4.105 #317)
	id 1EdQ7o-0004X4-00
	for linux-scsi@vger.kernel.org; Sat, 19 Nov 2005 11:39:16 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

--Boundary-00=_TDwfDyJ1Aal593g
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hello,

I=B4m currently experiencing trouble with my Nikon LS-2000 connected to a D=
omex=20
3194UW scsi card. The device is recognized upon module load, but as soon as=
 I=20
start a scanning application (Vuescan) the activity-LED on the controller=20
goes on and stays on, after a few minutes (2-3) the system hangs needing a=
=20
cold reset.

The scanner works fine under Win2K. I read about the termination issues, bu=
t=20
the Nikon has a built-in active termination (opened the device and verified=
=20
it=B4s not just an advertisment), so has the Domex scsi card. I ran the car=
d=20
without any problems with other devices (HP ScanJet 4p, Benq ScanWit 2920S)

With exact the same cabling and termination the Nikon works with a Adaptec=
=20
2940UW.

I enabled debugging in the initio module, the output is attatched to this=20
mail. The scsi driver doesn=B4t report any timeouts or bus resets prior to=
=20
hanging.=20

Any hints?



--Boundary-00=_TDwfDyJ1Aal593g
Content-Type: text/plain;
  charset="iso-8859-1";
  name="scsilog.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="scsilog.txt"

Nov 18 23:23:27 harry i91u: PCI Base=0xA000, IRQ=11, BIOS=0xFF000, SCSI ID=7
Nov 18 23:23:27 harry i91u: Reset SCSI Bus ... 
Nov 18 23:23:37 harry scsi3 : Initio INI-9X00U/UW SCSI device driver; Revision: 1.04a
Nov 18 23:23:37 harry find scb at c09cc000
Nov 18 23:23:37 harry Append pend SCB c09cc000; find done SCB 0; unlink pend SCB c09cc000; append done SCB c09cc000; find done SCB c09cc000; Release SCB c09cc000; find done SCB 0; find scb at c09cc154
Nov 18 23:23:38 harry Append pend SCB c09cc154; find done SCB 0; unlink pend SCB c09cc154; append done SCB c09cc154; find done SCB c09cc154; Release SCB c09cc154; find done SCB 0; find scb at c09cc2a8
Nov 18 23:23:38 harry Append pend SCB c09cc2a8; find done SCB 0; unlink pend SCB c09cc2a8; append done SCB c09cc2a8; find done SCB c09cc2a8; Release SCB c09cc2a8; find done SCB 0; find scb at c09cc3fc
Nov 18 23:23:38 harry Append pend SCB c09cc3fc; find done SCB 0; unlink pend SCB c09cc3fc; append done SCB c09cc3fc; find done SCB c09cc3fc; Release SCB c09cc3fc; find done SCB 0; find scb at c09cc550
Nov 18 23:23:38 harry Append pend SCB c09cc550; find done SCB 0; unlink pend SCB c09cc550; append done SCB c09cc550; find done SCB c09cc550; Release SCB c09cc550; find done SCB 0; find scb at c09cc6a4
Nov 18 23:23:39 harry Append pend SCB c09cc6a4; find done SCB 0; unlink pend SCB c09cc6a4; append done SCB c09cc6a4; find done SCB c09cc6a4; Release SCB c09cc6a4; find done SCB 0; find scb at c09cc7f8
Nov 18 23:23:39 harry Append pend SCB c09cc7f8; find done SCB 0; -s2-unlink pend SCB c09cc7f8; append busy SCB c09cc7f8; -s4-find done SCB 0; -s5--s6-unlink busy SCB c09cc7f8; append done SCB c09cc7f8; find done SCB c09cc7f8; Release SCB c09cc7f8; find done SCB 0; <5>  Vendor: Nikon     Model: LS-2000           Rev: 1.31
Nov 18 23:23:39 harry Type:   Scanner                            ANSI SCSI revision: 02
Nov 18 23:23:39 harry Attached scsi generic sg5 at scsi3, channel 0, id 6, lun 0,  type 6
Nov 18 23:23:39 harry find scb at c09cc94c
Nov 18 23:23:39 harry Append pend SCB c09cc94c; find done SCB 0; unlink pend SCB c09cc94c; append done SCB c09cc94c; find done SCB c09cc94c; Release SCB c09cc94c; find done SCB 0; find scb at c09ccaa0
Nov 18 23:23:39 harry Append pend SCB c09ccaa0; find done SCB 0; unlink pend SCB c09ccaa0; append done SCB c09ccaa0; find done SCB c09ccaa0; Release SCB c09ccaa0; find done SCB 0; find scb at c09ccbf4
Nov 18 23:23:39 harry Append pend SCB c09ccbf4; find done SCB 0; unlink pend SCB c09ccbf4; append done SCB c09ccbf4; find done SCB c09ccbf4; Release SCB c09ccbf4; find done SCB 0; find scb at c09ccd48
Nov 18 23:23:40 harry Append pend SCB c09ccd48; find done SCB 0; unlink pend SCB c09ccd48; append done SCB c09ccd48; find done SCB c09ccd48; Release SCB c09ccd48; find done SCB 0; find scb at c09cce9c
Nov 18 23:23:40 harry Append pend SCB c09cce9c; find done SCB 0; unlink pend SCB c09cce9c; append done SCB c09cce9c; find done SCB c09cce9c; Release SCB c09cce9c; find done SCB 0; find scb at c09ccff0
Nov 18 23:23:40 harry Append pend SCB c09ccff0; find done SCB 0; unlink pend SCB c09ccff0; append done SCB c09ccff0; find done SCB c09ccff0; Release SCB c09ccff0; find done SCB 0; find scb at c09cd144
Nov 18 23:23:40 harry Append pend SCB c09cd144; find done SCB 0; unlink pend SCB c09cd144; append done SCB c09cd144; find done SCB c09cd144; Release SCB c09cd144; find done SCB 0; find scb at c09cd298
(end of bus scan upon module load)
(starting vuescan application)
Nov 18 23:24:19 harry Append pend SCB c09cd298; find done SCB 0; unlink pend SCB c09cd298; append done SCB c09cd298; find done SCB c09cd298; Release SCB c09cd298; find done SCB 0; find scb at c09cd3ec
Nov 18 23:24:19 harry Append pend SCB c09cd3ec; find done SCB 0; -s2-unlink pend SCB c09cd3ec; append busy SCB c09cd3ec; -s4-find done SCB 0; -s5--s6-unlink busy SCB c09cd3ec; append done SCB c09cd3ec; find done SCB c09cd3ec; Release SCB c09cd3ec; find done SCB 0; find scb at c09cd540
Nov 18 23:24:19 harry Append pend SCB c09cd540; find done SCB 0; -s2-unlink pend SCB c09cd540; append busy SCB c09cd540; -s4-find done SCB 0; -s5--s6-unlink busy SCB c09cd540; append done SCB c09cd540; find done SCB c09cd540; Release SCB c09cd540; find done SCB 0; find scb at c09cd694
Nov 18 23:24:19 harry Append pend SCB c09cd694; find done SCB 0; -s2-unlink pend SCB c09cd694; append busy SCB c09cd694; -s4-find done SCB 0; -s5--s6-unlink busy SCB c09cd694; append done SCB c09cd694; find done SCB c09cd694; Release SCB c09cd694; find done SCB 0; find scb at c09cd7e8
Nov 18 23:24:19 harry Append pend SCB c09cd7e8; find done SCB 0; -s2-unlink pend SCB c09cd7e8; append busy SCB c09cd7e8; -s4-find done SCB 0; -s5--s6-unlink busy SCB c09cd7e8; append done SCB c09cd7e8; find done SCB c09cd7e8; Release SCB c09cd7e8; find done SCB 0; find scb at c09cd93c
Nov 18 23:24:19 harry Append pend SCB c09cd93c; find done SCB 0; -s2-unlink pend SCB c09cd93c; append busy SCB c09cd93c; -s4-find done SCB 0; -s5--s6-unlink busy SCB c09cd93c; append done SCB c09cd93c; find done SCB c09cd93c; Release SCB c09cd93c; find done SCB 0; find scb at c09cda90
Nov 18 23:24:19 harry Append pend SCB c09cda90; find done SCB 0; -s2-unlink pend SCB c09cda90; append busy SCB c09cda90; -s4-find done SCB 0; -s5--s6-unlink busy SCB c09cda90; append done SCB c09cda90; find done SCB c09cda90; Release SCB c09cda90; find done SCB 0; find scb at c09cdbe4
Nov 18 23:24:19 harry Append pend SCB c09cdbe4; find done SCB 0; -s2-unlink pend SCB c09cdbe4; append busy SCB c09cdbe4; -s4-find done SCB 0; -s5--s6-unlink busy SCB c09cdbe4; append done SCB c09cdbe4; find done SCB c09cdbe4; Release SCB c09cdbe4; find done SCB 0; find scb at c09cdd38
Nov 18 23:24:19 harry Append pend SCB c09cdd38; find done SCB 0; -s2-unlink pend SCB c09cdd38; append busy SCB c09cdd38; -s4-find done SCB 0; -s5--s6-unlink busy SCB c09cdd38; append done SCB c09cdd38; find done SCB c09cdd38; Release SCB c09cdd38; find done SCB 0; find scb at c09cde8c
Nov 18 23:24:19 harry Append pend SCB c09cde8c; find done SCB 0; -s2-unlink pend SCB c09cde8c; append busy SCB c09cde8c; -s4-find done SCB 0; -s5--s6-unlink busy SCB c09cde8c; append done SCB c09cde8c; find done SCB c09cde8c; Release SCB c09cde8c; find done SCB 0; find scb at c09cdfe0
Nov 18 23:24:19 harry Append pend SCB c09cdfe0; find done SCB 0; -s2-unlink pend SCB c09cdfe0; append busy SCB c09cdfe0; -s4-find done SCB 0; -s5--s6-unlink busy SCB c09cdfe0; append done SCB c09cdfe0; find done SCB c09cdfe0; Release SCB c09cdfe0; find done SCB 0; find scb at c09ce134
Nov 18 23:24:19 harry Append pend SCB c09ce134; find done SCB 0; -s2-unlink pend SCB c09ce134; append busy SCB c09ce134; -s4-find done SCB 0; -s5--s6-unlink busy SCB c09ce134; append done SCB c09ce134; find done SCB c09ce134; Release SCB c09ce134; find done SCB 0; find scb at c09ce288
Nov 18 23:24:19 harry Append pend SCB c09ce288; find done SCB 0; -s2-unlink pend SCB c09ce288; append busy SCB c09ce288; -s4-find done SCB 0; -s5--s6-unlink busy SCB c09ce288; append done SCB c09ce288; find done SCB c09ce288; Release SCB c09ce288; find done SCB 0; find scb at c09ce3dc
Nov 18 23:24:19 harry Append pend SCB c09ce3dc; find done SCB 0; -s2-unlink pend SCB c09ce3dc; append busy SCB c09ce3dc; -s4-find done SCB 0; -s5--s6-unlink busy SCB c09ce3dc; append done SCB c09ce3dc; find done SCB c09ce3dc; Release SCB c09ce3dc; find done SCB 0; find scb at c09ce530
Nov 18 23:24:19 harry Append pend SCB c09ce530; find done SCB 0; -s2-unlink pend SCB c09ce530; append busy SCB c09ce530; -s4-find done SCB 0; -s5--s6-unlink busy SCB c09ce530; append done SCB c09ce530; find done SCB c09ce530; Release SCB c09ce530; find done SCB 0; find scb at c09ce684
Nov 18 23:24:19 harry Append pend SCB c09ce684; find done SCB 0; -s2-unlink pend SCB c09ce684; append busy SCB c09ce684; -s4-find done SCB 0; -s5--s6-unlink busy SCB c09ce684; append done SCB c09ce684; find done SCB c09ce684; Release SCB c09ce684; find done SCB 0; find scb at c09ce7d8
Nov 18 23:24:19 harry Append pend SCB c09ce7d8; find done SCB 0; -s2-unlink pend SCB c09ce7d8; append busy SCB c09ce7d8; -s4-find done SCB 0; -s5--s6-unlink busy SCB c09ce7d8; append done SCB c09ce7d8; find done SCB c09ce7d8; Release SCB c09ce7d8; find done SCB 0; find scb at c09ce92c
Nov 18 23:24:19 harry Append pend SCB c09ce92c; find done SCB 0; -s2-unlink pend SCB c09ce92c; append busy SCB c09ce92c; -s4-find done SCB 0; -s5--s6-unlink busy SCB c09ce92c; append done SCB c09ce92c; find done SCB c09ce92c; Release SCB c09ce92c; find done SCB 0; find scb at c09cc000
Nov 18 23:24:19 harry Append pend SCB c09cc000; find done SCB 0; -s2-unlink pend SCB c09cc000; append busy SCB c09cc000; -s4-find done SCB 0; -s5--s6-unlink busy SCB c09cc000; append done SCB c09cc000; find done SCB c09cc000; Release SCB c09cc000; find done SCB 0; find scb at c09cc154
Nov 18 23:24:19 harry Append pend SCB c09cc154; find done SCB 0; -s2-unlink pend SCB c09cc154; append busy SCB c09cc154; -s4-find done SCB 0; -s5--s6-unlink busy SCB c09cc154; append done SCB c09cc154; find done SCB c09cc154; Release SCB c09cc154; find done SCB 0; find scb at c09cc2a8
Nov 18 23:24:19 harry Append pend SCB c09cc2a8; find done SCB 0; -s2-unlink pend SCB c09cc2a8; append busy SCB c09cc2a8; -s4-find done SCB 0; -s5--s6-unlink busy SCB c09cc2a8; append done SCB c09cc2a8; find done SCB c09cc2a8; Release SCB c09cc2a8; find done SCB 0; find scb at c09cc3fc
Nov 18 23:24:19 harry Append pend SCB c09cc3fc; find done SCB 0; -s2-unlink pend SCB c09cc3fc; append busy SCB c09cc3fc; -s4-find done SCB 0; -s5--s6-unlink busy SCB c09cc3fc; append done SCB c09cc3fc; find done SCB c09cc3fc; Release SCB c09cc3fc; find done SCB 0; find scb at c09cc550
Nov 18 23:24:19 harry Append pend SCB c09cc550; find done SCB 0; -s2-unlink pend SCB c09cc550; append busy SCB c09cc550; -s4-find done SCB 0; -s5--s6-unlink busy SCB c09cc550; append done SCB c09cc550; find done SCB c09cc550; Release SCB c09cc550; find done SCB 0; find scb at c09cc6a4
Nov 18 23:24:19 harry Append pend SCB c09cc6a4; find done SCB 0; -s2-unlink pend SCB c09cc6a4; append busy SCB c09cc6a4; -s4-find done SCB 0; -s5--s6-unlink busy SCB c09cc6a4; append done SCB c09cc6a4; find done SCB c09cc6a4; Release SCB c09cc6a4; find done SCB 0; find scb at c09cc7f8
Nov 18 23:24:19 harry Append pend SCB c09cc7f8; find done SCB 0; -s2-unlink pend SCB c09cc7f8; append busy SCB c09cc7f8; -s4-find done SCB 0; -s5--s6-unlink busy SCB c09cc7f8; append done SCB c09cc7f8; find done SCB c09cc7f8; Release SCB c09cc7f8; find done SCB 0; find scb at c09cc94c
Nov 18 23:24:19 harry Append pend SCB c09cc94c; find done SCB 0; -s2-unlink pend SCB c09cc94c; append busy SCB c09cc94c; -s4-find done SCB 0; -s5--s6-unlink busy SCB c09cc94c; append done SCB c09cc94c; find done SCB c09cc94c; Release SCB c09cc94c; find done SCB 0; find scb at c09ccaa0
Nov 18 23:24:19 harry Append pend SCB c09ccaa0; find done SCB 0; -s2-unlink pend SCB c09ccaa0; append busy SCB c09ccaa0; -s4-find done SCB 0; -s5--s6-unlink busy SCB c09ccaa0; append done SCB c09ccaa0; find done SCB c09ccaa0; Release SCB c09ccaa0; find done SCB 0; find scb at c09ccbf4
Nov 18 23:24:19 harry Append pend SCB c09ccbf4; find done SCB 0; -s2-unlink pend SCB c09ccbf4; append busy SCB c09ccbf4; -s4-find done SCB 0; -s5--s6-unlink busy SCB c09ccbf4; append done SCB c09ccbf4; find done SCB c09ccbf4; Release SCB c09ccbf4; find done SCB 0; find scb at c09ccd48
Nov 18 23:24:19 harry Append pend SCB c09ccd48; find done SCB 0; -s2-unlink pend SCB c09ccd48; append busy SCB c09ccd48; -s4-find done SCB 0; -s5--s6-unlink busy SCB c09ccd48; append done SCB c09ccd48; find done SCB c09ccd48; Release SCB c09ccd48; find done SCB 0; find scb at c09cce9c
Nov 18 23:24:19 harry Append pend SCB c09cce9c; find done SCB 0; -s2-unlink pend SCB c09cce9c; append busy SCB c09cce9c; -s4-find done SCB 0; -s5--s6-unlink busy SCB c09cce9c; append done SCB c09cce9c; find done SCB c09cce9c; Release SCB c09cce9c; find done SCB 0; find scb at c09ccff0
Nov 18 23:24:19 harry Append pend SCB c09ccff0; find done SCB 0; -s2-unlink pend SCB c09ccff0; append busy SCB c09ccff0; -s4-find done SCB 0; -s5--s6-unlink busy SCB c09ccff0; append done SCB c09ccff0; find done SCB c09ccff0; Release SCB c09ccff0; find done SCB 0; find scb at c09cd144
Nov 18 23:24:19 harry Append pend SCB c09cd144; find done SCB 0; -s2-unlink pend SCB c09cd144; append busy SCB c09cd144; -s4-find done SCB 0; -s5--s6-unlink busy SCB c09cd144; append done SCB c09cd144; find done SCB c09cd144; Release SCB c09cd144; find done SCB 0; find scb at c09cd298
Nov 18 23:24:19 harry Append pend SCB c09cd298; find done SCB 0; -s2-unlink pend SCB c09cd298; append busy SCB c09cd298; -s4-find done SCB 0; -s5--s6-unlink busy SCB c09cd298; append done SCB c09cd298; find done SCB c09cd298; Release SCB c09cd298; find done SCB 0; find scb at c09cd3ec
Nov 18 23:24:19 harry Append pend SCB c09cd3ec; find done SCB 0; -s2-unlink pend SCB c09cd3ec; append busy SCB c09cd3ec; -s4-find done SCB 0; -s5--s6-unlink busy SCB c09cd3ec; append done SCB c09cd3ec; find done SCB c09cd3ec; Release SCB c09cd3ec; find done SCB 0; find scb at c09cd540
Nov 18 23:24:19 harry Append pend SCB c09cd540; find done SCB 0; -s2-unlink pend SCB c09cd540; append busy SCB c09cd540; -s4-find done SCB 0; -s5--s6-unlink busy SCB c09cd540; append done SCB c09cd540; find done SCB c09cd540; Release SCB c09cd540; find done SCB 0; find scb at c09cd694
Nov 18 23:24:19 harry Append pend SCB c09cd694; find done SCB 0; -s2-unlink pend SCB c09cd694; append busy SCB c09cd694; -s4-find done SCB 0; -s5--s6-unlink busy SCB c09cd694; append done SCB c09cd694; find done SCB c09cd694; Release SCB c09cd694; find done SCB 0; find scb at c09cd7e8
Nov 18 23:24:19 harry Append pend SCB c09cd7e8; find done SCB 0; -s2-unlink pend SCB c09cd7e8; append busy SCB c09cd7e8; -s4--s6-unlink busy SCB c09cd7e8; append done SCB c09cd7e8; find done SCB c09cd7e8; Push pend SCB c09cd7e8; find done SCB 0; -s2-unlink pend SCB c09cd7e8; append busy SCB c09cd7e8; -s4-find done SCB 0; -s5--s6-unlink busy SCB c09cd7e8; append done SCB c09cd7e8; find done SCB c09cd7e8; Release SCB c09cd7e8; find done SCB 0; find scb at c09cd93c
Nov 18 23:24:19 harry Append pend SCB c09cd93c; find done SCB 0; -s2-unlink pend SCB c09cd93c; append busy SCB c09cd93c; -s4--s6-unlink busy SCB c09cd93c; append done SCB c09cd93c; find done SCB c09cd93c; Release SCB c09cd93c; find done SCB 0; find scb at c09cda90
Nov 18 23:24:19 harry Append pend SCB c09cda90; find done SCB 0; -s2-unlink pend SCB c09cda90; append busy SCB c09cda90; -s4-find done SCB 0; -s5--s6-unlink busy SCB c09cda90; append done SCB c09cda90; find done SCB c09cda90; Release SCB c09cda90; find done SCB 0; find scb at c09cdbe4
Nov 18 23:24:19 harry Append pend SCB c09cdbe4; find done SCB 0; -s2-unlink pend SCB c09cdbe4; append busy SCB c09cdbe4; -s4-find done SCB 0; -s5--s6-unlink busy SCB c09cdbe4; append done SCB c09cdbe4; find done SCB c09cdbe4; Release SCB c09cdbe4; find done SCB 0; find scb at c09cdd38
Nov 18 23:24:19 harry Append pend SCB c09cdd38; find done SCB 0; -s2-unlink pend SCB c09cdd38; append busy SCB c09cdd38; -s4-find done SCB 0; -s5--s6-unlink busy SCB c09cdd38; append done SCB c09cdd38; find done SCB c09cdd38; Release SCB c09cdd38; find done SCB 0; find scb at c09cde8c
Nov 18 23:24:19 harry Append pend SCB c09cde8c; find done SCB 0; -s2-unlink pend SCB c09cde8c; append busy SCB c09cde8c; -s4-find done SCB 0; -s5--s6-unlink busy SCB c09cde8c; append done SCB c09cde8c; find done SCB c09cde8c; Release SCB c09cde8c; find done SCB 0; find scb at c09cdfe0
Nov 18 23:24:19 harry Append pend SCB c09cdfe0; find done SCB 0; -s2-unlink pend SCB c09cdfe0; append busy SCB c09cdfe0; -s4--s6-unlink busy SCB c09cdfe0; append done SCB c09cdfe0; find done SCB c09cdfe0; Push pend SCB c09cdfe0; find done SCB 0; -s2-unlink pend SCB c09cdfe0; append busy SCB c09cdfe0; -s4-find done SCB 0; -s5--s6-unlink busy SCB c09cdfe0; append done SCB c09cdfe0; find done SCB c09cdfe0; Release SCB c09cdfe0; find done SCB 0; find scb at c09ce134
Nov 18 23:24:19 harry Append pend SCB c09ce134; find done SCB 0; -s2-unlink pend SCB c09ce134; append busy SCB c09ce134; -s4-find done SCB 0; -s5--s6-unlink busy SCB c09ce134; append done SCB c09ce134; find done SCB c09ce134; Release SCB c09ce134; find done SCB 0; find scb at c09ce288
Nov 18 23:24:19 harry Append pend SCB c09ce288; find done SCB 0; -s2-unlink pend SCB c09ce288; append busy SCB c09ce288; -s4-find done SCB 0; -s5--s6-unlink busy SCB c09ce288; append done SCB c09ce288; find done SCB c09ce288; Release SCB c09ce288; find done SCB 0; find scb at c09ce3dc
Nov 18 23:24:19 harry Append pend SCB c09ce3dc; find done SCB 0; -s2-unlink pend SCB c09ce3dc; append busy SCB c09ce3dc; -s4-find done SCB 0; -s5--s6-unlink busy SCB c09ce3dc; append done SCB c09ce3dc; find done SCB c09ce3dc; Release SCB c09ce3dc; find done SCB 0; find scb at c09ce530
Nov 18 23:24:19 harry Append pend SCB c09ce530; find done SCB 0; -s2-unlink pend SCB c09ce530; append busy SCB c09ce530; -s4-find done SCB 0; -s5--s6-unlink busy SCB c09ce530; append done SCB c09ce530; find done SCB c09ce530; Release SCB c09ce530; find done SCB 0; find scb at c09ce684
Nov 18 23:24:19 harry Append pend SCB c09ce684; find done SCB 0; -s2-unlink pend SCB c09ce684; append busy SCB c09ce684; -s4-find done SCB 0; -s5--s6-unlink busy SCB c09ce684; append done SCB c09ce684; find done SCB c09ce684; Release SCB c09ce684; find done SCB 0; find scb at c09ce7d8
Nov 18 23:24:19 harry Append pend SCB c09ce7d8; find done SCB 0; -s2-unlink pend SCB c09ce7d8; append busy SCB c09ce7d8; -s4--s6-unlink busy SCB c09ce7d8; append done SCB c09ce7d8; find done SCB c09ce7d8; Push pend SCB c09ce7d8; find done SCB 0; -s2-unlink pend SCB c09ce7d8; append busy SCB c09ce7d8; -s4-find done SCB 0; -s5--s6-unlink busy SCB c09ce7d8; append done SCB c09ce7d8; find done SCB c09ce7d8; Release SCB c09ce7d8; find done SCB 0; find scb at c09ce92c
Nov 18 23:24:19 harry Append pend SCB c09ce92c; find done SCB 0; -s2-unlink pend SCB c09ce92c; append busy SCB c09ce92c; -s4-find done SCB 0; -s5--s6-unlink busy SCB c09ce92c; append done SCB c09ce92c; find done SCB c09ce92c; Release SCB c09ce92c; find done SCB 0; find scb at c09cc000
Nov 18 23:24:19 harry Append pend SCB c09cc000; find done SCB 0; -s2-unlink pend SCB c09cc000; append busy SCB c09cc000; -s4-find done SCB 0; -s5--s6-unlink busy SCB c09cc000; append done SCB c09cc000; find done SCB c09cc000; Release SCB c09cc000; find done SCB 0; find scb at c09cc154
Nov 18 23:24:20 harry Append pend SCB c09cc154; find done SCB 0; -s2-unlink pend SCB c09cc154; append busy SCB c09cc154; -s4-find done SCB 0; -s5--s6-unlink busy SCB c09cc154; append done SCB c09cc154; find done SCB c09cc154; Release SCB c09cc154; find done SCB 0; find scb at c09cc2a8
Nov 18 23:24:20 harry Append pend SCB c09cc2a8; find done SCB 0; -s2-unlink pend SCB c09cc2a8; append busy SCB c09cc2a8; -s4-find done SCB 0; -s5--s6-unlink busy SCB c09cc2a8; append done SCB c09cc2a8; find done SCB c09cc2a8; Release SCB c09cc2a8; find done SCB 0; find scb at c09cc3fc
Nov 18 23:24:20 harry Append pend SCB c09cc3fc; find done SCB 0; -s2-unlink pend SCB c09cc3fc; append busy SCB c09cc3fc; -s4--s6-unlink busy SCB c09cc3fc; append done SCB c09cc3fc; find done SCB c09cc3fc; Release SCB c09cc3fc; find done SCB 0; find scb at c09cc550
Nov 18 23:24:20 harry Append pend SCB c09cc550; find done SCB 0; -s2-unlink pend SCB c09cc550; append busy SCB c09cc550; -s4-find done SCB 0; -s5--s6-unlink busy SCB c09cc550; append done SCB c09cc550; find done SCB c09cc550; Release SCB c09cc550; find done SCB 0; find scb at c09cc6a4
Nov 18 23:24:20 harry Append pend SCB c09cc6a4; find done SCB 0; -s2-unlink pend SCB c09cc6a4; append busy SCB c09cc6a4; -s4--s6-unlink busy SCB c09cc6a4; append done SCB c09cc6a4; find done SCB c09cc6a4; Release SCB c09cc6a4; find done SCB 0; find scb at c09cc7f8
Nov 18 23:24:20 harry Append pend SCB c09cc7f8; find done SCB 0; -s2-unlink pend SCB c09cc7f8; append busy SCB c09cc7f8; -s4--s6-unlink busy SCB c09cc7f8; append done SCB c09cc7f8; find done SCB c09cc7f8; Push pend SCB c09cc7f8; find done SCB 0; -s2-unlink pend SCB c09cc7f8; append busy SCB c09cc7f8; -s4-find done SCB 0; -s5--s6-unlink busy SCB c09cc7f8; append done SCB c09cc7f8; find done SCB c09cc7f8; Release SCB c09cc7f8; find done SCB 0; find scb at c09cc94c
Nov 18 23:24:20 harry Append pend SCB c09cc94c; find done SCB 0; -s2-unlink pend SCB c09cc94c; append busy SCB c09cc94c; -s4-find done SCB 0; -s5--s6-unlink busy SCB c09cc94c; append done SCB c09cc94c; find done SCB c09cc94c; Release SCB c09cc94c; find done SCB 0; find scb at c09ccaa0

from this point, the system waits for some minutes, while controller LED is
on, after that time the system hangs
--Boundary-00=_TDwfDyJ1Aal593g--
