From: James Smart <James.Smart@Emulex.Com>
Subject: [Patch 0/5] lpfc 8.3.3: Update lpfc driver to revision 8.3.3
Date: Wed, 10 Jun 2009 17:22:32 -0400
Message-ID: <1244668952.9571.13.camel@ogier>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:37876 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755281AbZFJVWd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Jun 2009 17:22:33 -0400
Received: from xcm.ad.emulex.com (xcm.emulex.com [138.239.112.69])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id n5ALMa8R001323
	for <linux-scsi@vger.kernel.org>; Wed, 10 Jun 2009 14:22:36 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

This patch set updates the lpfc driver to revision 8.3.3

The changes in the 8.3.3 patch set are:
- Fix various SLI-3 vs SLI-4 differences
- FC/FCoE discovery fixes
- Fix a couple of spin_lock and memory issues and a crash
- Add support for Target Reset handler entrypoint
- Update driver version to 8.3.3

The patches are prepared against scsi-misc-2.6 and are expected to
merged into 2.6.31.


-- james s


 Signed-off-by: James Smart <james.smart@emulex.com>



