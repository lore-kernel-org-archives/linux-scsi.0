From: Meelis Roos <mroos@linux.ee>
Subject: 2.6.17-rc1+git, Sym2: unknown symbol pcibios_resource_to_bus
Date: Mon, 17 Apr 2006 13:22:36 +0300 (EEST)
Message-ID: <Pine.SOC.4.61.0604171318410.5555@math.ut.ee>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from math.ut.ee ([193.40.36.2]:56568 "EHLO math.ut.ee")
	by vger.kernel.org with ESMTP id S1750739AbWDQKWr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Apr 2006 06:22:47 -0400
Received: from math.ut.ee (localhost [IPv6:::1])
	by math.ut.ee (8.12.8+Sun/8.12.8/math-1.2) with ESMTP id k3HAMaK7018440
	for <linux-scsi@vger.kernel.org>; Mon, 17 Apr 2006 13:22:36 +0300 (EEST)
Received: from localhost (mroos@localhost)
	by math.ut.ee (8.12.8+Sun/8.12.2/Submit) with ESMTP id k3HAMaN5018434
	for <linux-scsi@vger.kernel.org>; Mon, 17 Apr 2006 13:22:36 +0300 (EEST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

WARNING: /lib/modules/2.6.17-rc1-gc19f7a9e/kernel/drivers/scsi/sym53c8xx_2/sym53c8xx.ko needs unknown symbol pcibios_resource_to_bus

Is is something missing from sparc64, or is sym53c8xx using something 
arch-specific (pcibios sounds like it)?

It's introduced by [SCSI] Use pcibios_resource_to_bus()

-- 
Meelis Roos (mroos@linux.ee)
