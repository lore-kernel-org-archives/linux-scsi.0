From: James Smart <James.Smart@Emulex.Com>
Subject: [Patch 0/8] lpfc 8.3.4: Update lpfc driver to revision 8.3.4
Date: Sun, 19 Jul 2009 10:00:57 -0400
Message-ID: <1248012057.15009.20.camel@ogier>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:34656 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754349AbZGSOA7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Jul 2009 10:00:59 -0400
Received: from xcm.ad.emulex.com (xcm.emulex.com [138.239.112.69])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id n6JE0wSE021554
	for <linux-scsi@vger.kernel.org>; Sun, 19 Jul 2009 07:00:59 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

This patch set updates the lpfc driver to revision 8.3.4

The changes in the 8.3.4 patch set are:
- Various SLI4 fixes
- Consistently implement persistent port disable
- Various SLI3 fixes
- Fix a pair of FCoE issues
- NPIV vport fixes
- Add bsg (SGIOv4) support for sending and receiving ELS, CT commands
- Remove spaces before newlines in several log messages
- Update driver version to 8.3.4

The patches are prepared against scsi-misc-2.6


-- james s





