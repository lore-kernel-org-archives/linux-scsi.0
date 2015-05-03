From: Ondrej Zary <linux@rainbow-software.org>
Subject: [RFC PATCH 00/34] atp870u: Remove the first level of crap
Date: Sun,  3 May 2015 19:31:16 +0200
Message-ID: <1430674310-11576-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:35973 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750776AbbECRcG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 3 May 2015 13:32:06 -0400
Received: from stip-static-68.213-81-217.telecom.sk ([213.81.217.68] helo=gsql.ggedos.sk)
	by gsystem.sk with esmtpsa (TLS1.1:DHE_RSA_AES_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <linux@rainbow-software.org>)
	id 1YoxkI-0000Ql-U1
	for linux-scsi@vger.kernel.org; Sun, 03 May 2015 19:32:03 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This patch series removes the first level of crap from atp870u - the worst
(in-tree) SCSI driver [1], allowing some more work to be done next.

First the driver is converted to C from something that looks like a (bad)
assembler code: use of tmport for all I/O accesses and gotos all over the
code.
Then I/O access wrappers are introduced.
Finally, is870, is880 and is885 are unified and two of them removed.

Tested on AEC-6710D (ATP870IU-C).

[1] http://www.spinics.net/lists/linux-scsi/msg81142.html

 atp870u.c | 3226 ++++++++++++++++----------------------------------------------
 1 file changed, 880 insertions(+), 2346 deletions(-)

-- 
Ondrej Zary
