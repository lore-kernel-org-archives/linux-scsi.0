From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: [PATCH] CDC_MMC_WR
Date: 06 Nov 2003 09:32:35 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1068136355.23487.44.camel@patrh9>
References: <1067647915.2682.5.camel@patrh9>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:65154 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S263715AbTKFQdC
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Nov 2003 11:33:02 -0500
Received: from royntex01.iomegacorp.com (unknown [147.178.90.120])
	by email.iomega.com (Postfix) with ESMTP id B2B9C2909
	for <linux-scsi@vger.kernel.org>; Thu,  6 Nov 2003 09:33:00 -0700 (MST)
In-Reply-To: <1067647915.2682.5.camel@patrh9>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Kindly offline I hear we want a better patch, specifically:

Have "the ->writeable bit actually be set if the device is writeable".

Anybody able to help me decrypt that remark more rapidly?

Does the ->writeable bit exist for ide-cd devices, or only for sr
devices?

When cdrom.ko decides a device is not writable, how does cdrom.ko name
that bit, else how does cdrom.ko call into ide-cd/sr to clear that bit?

Pat LaVarre

P.S. The 2.4.22 version of this 2.6.0-test7 -test8 -test9 patch is:

http://marc.theaimsgroup.com/?l=linux-scsi&m=106764981303759

List:     linux-scsi
Subject:  [PATCH] Backport CDC_MMC_WR
Date:     2003-11-01 1:22:49


