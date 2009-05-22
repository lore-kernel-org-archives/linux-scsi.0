From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 0/17] lpfc 8.3.2 : Update lpfc to revision 8.3.2
Date: Fri, 22 May 2009 14:50:35 -0400
Message-ID: <1243018235.7729.37.camel@ogier>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:41830 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713AbZEVSuh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 May 2009 14:50:37 -0400
Received: from xcm.ad.emulex.com (xcm.emulex.com [138.239.112.69])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id n4MIocAD029549
	for <linux-scsi@vger.kernel.org>; Fri, 22 May 2009 11:50:38 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

This patch set updates the lpfc driver to revision 8.3.2

Emulex is releasing support for a new adapter which supports FCOE and a
next gen interface definition.  The interface definition keeps much of
the prior message content and semantics, allowing the bulk of our
discovery engine and interface into the midlayer to remain largely
intact. However, as mentioned, the hardware interface presented to the
driver, and the way it manages interrupts and message passing with the
adapter, is quite different.

This patch set adds support for this new hardware and FCOE support.
The patch set reorgs the existing code so that the bottom layers, which
interact with the hardware, can be supported in a simple form, preserving
their use by higher level software layers.  The patch set then extends
the driver with the new interface support. Lastly, there's a couple of
bug fixes and new features in this driver rev.

The changes in the 8.3.2 patch set are:
- Reorganization for SLI4 - supplied in 3 parts
- Addition of SLI4 Interface - Base Support - supplied in 6 parts
- Addition of SLI4 Interface - Queues - supplied in 2 parts
- Addition of SLI4 Interface - Mailbox handling
- Addition of SLI4 Interface - FCOE Discovery support
- Update of copyrights on modified files
- Miscellaneous Changes
- Add support for persistent vport definitions and some misc fixes
- Update the driver version to 8.3.2


-- james s

Note: converting from our own source control to this patch set was an
interesting process. I believe I logically separated the changes, but
don't be surprised to see a few random changes that perhaps aren't in
the right patch set.


 Signed-off-by: James Smart <james.smart@emulex.com>



