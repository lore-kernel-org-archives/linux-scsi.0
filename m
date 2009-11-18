From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 0/6] lpfc 8.3.6 : Update lpfc driver to version 8.3.6
Date: Wed, 18 Nov 2009 15:39:07 -0500
Message-ID: <1258576767.29086.12.camel@wookie>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:50796 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758235AbZKRUkE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Nov 2009 15:40:04 -0500
Received: from xcm.ad.emulex.com (xcm.emulex.com [138.239.112.69])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id nAIKe9Qh012604
	for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2009 12:40:09 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This patch set updates the lpfc driver to revision 8.3.6

The patches for 8.3.6 contain:
- FCoE Protocol fixes.
- FC protocol fixes.
- Fix AER issues.
- Fix critical errors
- Hardware related Fixes and Changes.
- Update lpfc driver version to 8.3.6

The patches are preparted against scsi-misc-2.6, for inclusion
into the 2.6.33 merge window, and are dependent upon the 8.3.5
patch set that posted on 10/2/2009 (and have yet to be merged):
http://marc.info/?l=linux-scsi&m=125451353307197&w=2

-- james s

  Signed-off-by: James Smart <james.smart@emulex.com>




