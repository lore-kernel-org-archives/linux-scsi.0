From: <anil.gurumurthy@qlogic.com>
Subject: [PATCH 0/2] Patches for scsi "misc" branch
Date: Thu, 13 Aug 2015 06:41:50 -0400
Message-ID: <1439462512-1911-1-git-send-email-anil.gurumurthy@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:21591 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751452AbbHML2c (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Aug 2015 07:28:32 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, hch@infradead.org
Cc: linux-scsi@vger.kernel.org, sudarsana.kalluru@qlogic.com, Anil Gurumurthy <anil.gurumurthy@qlogic.com>

From: Anil Gurumurthy <anil.gurumurthy@qlogic.com>

Hi James, Christoph,

Please apply the following patches to the scsi tree, misc branch  at your
earliest convenience.

Thanks,
Anil

Anil Gurumurthy (2):
  bfa: Fix indentation
  bfa: Fix incorrect de-reference of pointer

 drivers/scsi/bfa/bfa_ioc.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

-- 
1.7.10.4

