From: Tomasz Torcz <tomek@pipebreaker.pl>
Subject: can't access LUN >2TB with aic7xxx, Infortrend EonStor and
	2.6.31-rc1
Date: Mon, 29 Jun 2009 15:08:35 +0200
Message-ID: <20090629130835.GA3657@mother.pipebreaker.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 193-34-3-65.chelmnet.pl ([193.34.3.65]:44012 "EHLO
	mother.pipebreaker.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755084AbZF2NSd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jun 2009 09:18:33 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: tomek@pipebreaker.pl


  Hello,

  recently I've acquired Infortrend EonStor A16U-G2421 array
with 16x 500GB SATA drives inside. It is connected via:
04:00.0 SCSI storage controller: Adaptec AHA-2940U2/U2W
to host running Fedora 12 with following kernel:
2.6.31-0.33.rc1.git2.fc12.x86_64

  When I export LUN >2TB from array I got following errors:

scsi 5:0:0:1: Direct-Access     VW       VRU1610          347G PQ: 0 ANSI: 5
scsi target5:0:0: FAST-40 WIDE SCSI 80.0 MB/s ST (25 ns, offset 127)
scsi5:A:0:1: Tagged Queuing enabled.  Depth 4
sd 5:0:0:1: Attached scsi generic sg3 type 0
sd 5:0:0:1: [sdd] READ CAPACITY(16) failed
sd 5:0:0:1: [sdd] Result: hostbyte=DID_ABORT driverbyte=DRIVER_OK
sd 5:0:0:1: [sdd] Sense not available.
sd 5:0:0:1: [sdd] 4294967296 512-byte logical blocks: (2.19 TB/2.00 TiB)
sd 5:0:0:1: [sdd] Write Protect is off
sd 5:0:0:1: [sdd] Mode Sense: 9b 00 00 08
sd 5:0:0:1: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 5:0:0:1: [sdd] READ CAPACITY(16) failed
sd 5:0:0:1: [sdd] Result: hostbyte=DID_ABORT driverbyte=DRIVER_OK
sd 5:0:0:1: [sdd] Sense not available.
 sdd: unknown partition table
sd 5:0:0:1: [sdd] READ CAPACITY(16) failed
sd 5:0:0:1: [sdd] Result: hostbyte=DID_ABORT driverbyte=DRIVER_OK
sd 5:0:0:1: [sdd] Sense not available.
sd 5:0:0:1: [sdd] Attached SCSI disk

  According to manufacturer, this array supports LUNs up to 64TB, 
although >2TB LUNs require enigmatic ,,support from OS side''.
I was under impression that aic7xxx supports them, but it seems
not true. What can I tweak on the Linux side to use 6TB volumes?

(please keep CCs to me on reply)
-- 
Tomasz Torcz                 "God, root, what's the difference?"
xmpp: zdzichubg@chrome.pl         "God is more forgiving."

