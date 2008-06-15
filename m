From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 0/5] lpfc 8.2.7 : lpfc 8.2.7 patch set
Date: Sat, 14 Jun 2008 22:52:29 -0400
Message-ID: <1213498349.10002.8.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:33061 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754715AbYFOCwc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 14 Jun 2008 22:52:32 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id m5F2qVvC018768
	for <linux-scsi@vger.kernel.org>; Sat, 14 Jun 2008 19:52:32 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


The following patches raise the lpfc driver to revision 8.2.7

The following changes are included:
- Change device reset behavior. 
- Discovery Fixes:
- Rework of the worker thread to make it more efficient. 
- Miscellaneous Fixes:
- Update lpfc driver version to 8.2.7

Patches were cut against scsi-misc-2.6

-- james s




