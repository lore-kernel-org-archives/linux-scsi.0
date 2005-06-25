From: James.Smart@Emulex.Com
Subject: [PATCH 0 of 12] Update Emulex lpfc driver to rev 8.0.29
Date: Sat, 25 Jun 2005 10:33:54 -0400
Message-ID: <9BB4DECD4CFE6D43AA8EA8D768ED51C20F4145@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:35518 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S261235AbVFYOd4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 25 Jun 2005 10:33:56 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id j5PEXs9P008156
	for <linux-scsi@vger.kernel.org>; Sat, 25 Jun 2005 07:33:55 -0700 (PDT)
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


This set of patches updates the Emulex lpfc driver to revision 8.0.29.

Patch 1 - hgp/pgp cleanups from Christoph Hellwig

Patch 2 - Fix issue where all hosts log nodev message for other initiators

Patch 3 - Fixes in mbox_timeout_handler

Patch 4 - Fix error loading lpfc on sparc

Patch 5 - Set max_sectors in host template

Patch 6 - Add LP6000 PCI ID

Patch 7 - Fix LS_RJT never sent by lpfc_els_unsol_event()

Patch 8 - Add completion handler to the abort iocbs

Patch 9 - Fix ADISC completion incorrectly putting initiators on mapped list

Patch 10 - Remove $Id$ keyword strings.

Patch 11 - Update copyright notices

Patch 12 - Change version to 8.0.29.

-- James Smart
