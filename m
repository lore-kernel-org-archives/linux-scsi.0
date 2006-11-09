From: Alexis Bruemmer <alexisb@us.ibm.com>
Subject: [PATCH 0/4]  aic94xx: Stabilizes discovery on platforms with
	expanders
Date: Thu, 09 Nov 2006 12:02:28 -0800
Message-ID: <1163102549.6521.13.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:6618 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S965559AbWKIUU4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Nov 2006 15:20:56 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e5.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id kA9KKtOS006860
	for <linux-scsi@vger.kernel.org>; Thu, 9 Nov 2006 15:20:55 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id kA9KGBmN255082
	for <linux-scsi@vger.kernel.org>; Thu, 9 Nov 2006 15:20:54 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id kA9K2Vgw021576
	for <linux-scsi@vger.kernel.org>; Thu, 9 Nov 2006 15:02:31 -0500
Received: from [9.48.54.0] ([9.48.54.0])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id kA9K2UHR021500
	for <linux-scsi@vger.kernel.org>; Thu, 9 Nov 2006 15:02:30 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Hi All,

This set of patches has been running on various x260, x366, and x206m
platforms with good success.  Although there are still some SMP timeouts
that need sorting out, this patch set certainly fixes various other
discovery issues on our expander based platforms. 

Thanks,

Alexis


