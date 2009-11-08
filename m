From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 0/2] libosd: bug fixes
Date: Sun, 08 Nov 2009 14:27:50 +0200
Message-ID: <4AF6B946.8000106@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dip-colo-pa.panasas.com ([67.152.220.67]:65379 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752178AbZKHM1u (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 8 Nov 2009 07:27:50 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd <osd-dev@open-osd.org>

These are two additional bug-fix patches to libosd for the
2.6.33 merge window.

Please consider for submission on top of the previous 5

[PATCH 1/2] libosd: bug in osd_req_decode_sense_full()
[PATCH 2/2] libosd: Bugfix of error handling in attributes-list decoding

Thanks
Boaz
