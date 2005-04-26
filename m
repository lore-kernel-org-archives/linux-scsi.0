From: "Jayashree, . (STSD)" <jayashree@hp.com>
Subject: regarding 2.6.9-6 diskdump driver
Date: Tue, 26 Apr 2005 18:20:46 +0530
Message-ID: <009917BCC3B63543BA9BCD212F9D177401BF95DB@bgeexc01.asiapacific.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bgerelbas01.asiapac.hp.net ([15.219.201.134]:54753 "EHLO
	bgerelbas01.ind.hp.com") by vger.kernel.org with ESMTP
	id S261497AbVDZMuw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Apr 2005 08:50:52 -0400
Received: from bgeexg11.asiapacific.cpqcorp.net (bgeexg11.asiapacific.cpqcorp.net [16.150.33.26])
	by bgerelbas01.ind.hp.com (Postfix) with ESMTP id B6F1432F7C
	for <linux-scsi@vger.kernel.org>; Tue, 26 Apr 2005 19:17:55 -0400 (EDT)
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

Currently I want to use diskdump functionality of aic7xxx.o driver.  I
am using RHEL 4 Update 1 (kernel 2.6.9-6.37). I am getting an error
while dumping the core.  I have few issues, please help me out resolving
the following issues or let me know whether I am using correct version
of drivers.

The issues are:

1.The sanity_check is giving an error with "No sane dump device". 

2.The stop routine of diskdump service util is not stopping the diskdump
process.

Thanks,
Jayasree


