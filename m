From: Jonathan Cameron <jic23@cam.ac.uk>
Subject: LSI megaraid sata 150 do now own errors.
Date: Thu, 25 Mar 2010 11:10:39 +0000
Message-ID: <4BAB44AF.10409@cam.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ppsw-1.csi.cam.ac.uk ([131.111.8.131]:59236 "EHLO
	ppsw-1.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753151Ab0CYLIO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Mar 2010 07:08:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Neela Syam Kolli <megaraidlinux@lsi.com>

Dear All,

A bit of googling shows that quite a few people have encountered the following error,
but I can't seem to track down any solutions.

It is a large array consisting of 4 2TB physical drives with latest firmware from LSI.

The are broken into 3 logical drives (2TB 2TB and 1.somethingTB) all raid 5.

[ 8687.145064] megaraid: 28 outstanding commands. Max wait 300 sec
[ 8687.145067] megaraid mbox: Wait for 28 commands to complete:300
[ 8688.150007] megaraid mbox: reset sequence completed sucessfully
[10556.394566] sd 4:1:2:0: [sdd] Asking for cache data failed
[10556.394579] sd 4:1:2:0: [sdd] Assuming drive cache: write through
[10556.394591]  sdd: sdd1
[13004.393214] megaraid: aborting-1476615 cmd=2a <c=1 t=2 l=0>
[13004.393220] megaraid abort: scsi cmd:1476615, do now own
[13004.393226] megaraid: aborting-1476616 cmd=2a <c=1 t=2 l=0>
[13004.393229] megaraid abort: scsi cmd:1476616, do now own
[13004.393232] megaraid: aborting-1476617 cmd=2a <c=1 t=2 l=0>
[13004.393234] megaraid abort: scsi cmd:1476617, do now own
[13004.393238] megaraid: aborting-1476618 cmd=2a <c=1 t=2 l=0>
[13004.393240] megaraid abort: scsi cmd:1476618, do now own
[13004.393243] megaraid: aborting-1476619 cmd=2a <c=1 t=2 l=0>
[13004.393245] megaraid abort: scsi cmd:1476619, do now own
[13004.393248] megaraid: aborting-1476620 cmd=2a <c=1 t=2 l=0>
[13004.393251] megaraid abort: scsi cmd:1476620, do now own
[13004.393254] megaraid: aborting-1476621 cmd=2a <c=1 t=2 l=0>
[13004.393256] megaraid abort: scsi cmd:1476621, do now own
[13004.393260] megaraid: aborting-1476622 cmd=2a <c=1 t=2 l=0>
[13004.393262] megaraid abort: scsi cmd:1476622, do now own
[13004.393265] megaraid: aborting-1476623 cmd=2a <c=1 t=2 l=0>
[13004.393267] megaraid abort: scsi cmd:1476623, do now own
[13004.393270] megaraid: aborting-1476624 cmd=2a <c=1 t=2 l=0>
[13004.393272] megaraid abort: scsi cmd:1476624, do now own
[13004.393276] megaraid: aborting-1476625 cmd=2a <c=1 t=2 l=0>
[13004.393278] megaraid abort: scsi cmd:1476625, do now own
[13004.393281] megaraid: aborting-1476626 cmd=2a <c=1 t=2 l=0>
[13004.393284] megaraid abort: scsi cmd:1476626, do now own
[13004.393287] megaraid: aborting-1476627 cmd=2a <c=1 t=2 l=0>
[13004.393289] megaraid abort: scsi cmd:1476627, do now own
[13004.393292] megaraid: aborting-1476628 cmd=2a <c=1 t=2 l=0>
[13004.393294] megaraid abort: scsi cmd:1476628, do now own
[13004.393297] megaraid: aborting-1476629 cmd=2a <c=1 t=2 l=0>
[13004.393300] megaraid abort: scsi cmd:1476629, do now own
[13004.393303] megaraid: aborting-1476630 cmd=2a <c=1 t=2 l=0>
[13004.393305] megaraid abort: scsi cmd:1476630, do now own
[13004.393309] megaraid: aborting-1476631 cmd=2a <c=1 t=2 l=0>
[13004.393311] megaraid abort: scsi cmd:1476631, do now own
[13004.393314] megaraid: aborting-1476632 cmd=2a <c=1 t=2 l=0>
[13004.393316] megaraid abort: scsi cmd:1476632, do now own
[13004.393319] megaraid: aborting-1476633 cmd=2a <c=1 t=2 l=0>
[13004.393322] megaraid abort: scsi cmd:1476633, do now own
[13004.393325] megaraid: aborting-1476634 cmd=2a <c=1 t=2 l=0>
[13004.393327] megaraid abort: scsi cmd:1476634, do now own
[13004.393330] megaraid: aborting-1476635 cmd=2a <c=1 t=2 l=0>
[13004.393333] megaraid abort: scsi cmd:1476635, do now own
[13004.393336] megaraid: aborting-1476636 cmd=2a <c=1 t=2 l=0>
[13004.393338] megaraid abort: scsi cmd:1476636, do now own
[13004.393341] megaraid: aborting-1476637 cmd=2a <c=1 t=2 l=0>
[13004.393343] megaraid abort: scsi cmd:1476637, do now own
[13004.393347] megaraid: aborting-1476638 cmd=2a <c=1 t=2 l=0>
[13004.393349] megaraid abort: scsi cmd:1476638, do now own
[13004.393352] megaraid: aborting-1476639 cmd=2a <c=1 t=2 l=0>
[13004.393354] megaraid abort: scsi cmd:1476639, do now own
[13004.393357] megaraid: aborting-1476640 cmd=2a <c=1 t=2 l=0>
[13004.393359] megaraid abort: scsi cmd:1476640, do now own
[13004.393362] megaraid: aborting-1476641 cmd=2a <c=1 t=2 l=0>
[13004.393365] megaraid abort: scsi cmd:1476641, do now own
[13004.393368] megaraid: aborting-1476642 cmd=2a <c=1 t=2 l=0>
[13004.393370] megaraid abort: scsi cmd:1476642, do now own

The result is that some cifs transfers fail with input output errors.
(at least I think the two are connected).

The load was reasonably high when the issue occured as there were about
10 simultaneous writes occuring of 1-2 Gig files.  The actual
bandwidth would have been fairly low though as the machine in question
is on a 100MB switch.

This is with ubuntu's 2.6.31-20-server.  I can check against 
a more recent tree if anyone knows of a reason that might help.

All suggests welcomed!

Thanks,

Jonathan
