From: wenxiong@linux.vnet.ibm.com
Subject: [ V3 PATCH 0/2] TUR path is down after adapter gets reset in multipath configuration
Date: Thu, 06 Nov 2014 15:11:21 -0600
Message-ID: <20141106211121.526781033@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [32.97.110.57] ([32.97.110.57]:58316 "HELO
	jupiter1-lp2.austin.ibm.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1751176AbaKFVRP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Nov 2014 16:17:15 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: hch@infradead.org, linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com

The first patch is unchanged and fold the logic back to scsi_dh_alua.c for
the second patch.

Thanks for your help!
Wendy
-- 
