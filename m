From: wenxiong@linux.vnet.ibm.com
Subject: [PATCH] Enclosure: fix WARN ON when doing dlpar removing an adapter in dual patch devices
Date: Fri, 16 Jan 2015 19:02:32 -0600
Message-ID: <1421456553-33828-1-git-send-email-wenxiong@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e37.co.us.ibm.com ([32.97.110.158]:57102 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640AbbAQAkb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Jan 2015 19:40:31 -0500
Received: from /spool/local
	by e37.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <wenxiong@linux.vnet.ibm.com>;
	Fri, 16 Jan 2015 17:40:31 -0700
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
	by d03dlp01.boulder.ibm.com (Postfix) with ESMTP id 9E4121FF0025
	for <linux-scsi@vger.kernel.org>; Fri, 16 Jan 2015 17:31:40 -0700 (MST)
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t0H0dDZA16122008
	for <linux-scsi@vger.kernel.org>; Fri, 16 Jan 2015 17:39:13 -0700
Received: from d03av03.boulder.ibm.com (localhost [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t0H0eRdR024605
	for <linux-scsi@vger.kernel.org>; Fri, 16 Jan 2015 17:40:28 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com, Wen Xiong <wenxiong@linux.vnet.ibm.com>

From: Wen Xiong <wenxiong@linux.vnet.ibm.com>

We saw lots of WARN ON errors in linux log when doing dlpar removing and adapter.
The patch fixes the issue.

Thanks,
Wendy

Wen Xiong (1):
  Subject: Enclosure: fix WARN ON when doing dlpar removing an adapter
    in dual patch devices

 drivers/misc/enclosure.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

