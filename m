From: "Kotian, Deepak" <Deepak.Kotian@patni.com>
Subject: add and remove scsi device when I/O is going on is possible?
Date: Fri, 18 Feb 2005 14:24:36 +0530
Message-ID: <374639AB1012AA4C840022842AA95BC2044AC02E@ruby.patni.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Received: from pcsmail.patni.com ([203.124.139.197]:57553 "EHLO
	pcsmail.patni.com") by vger.kernel.org with ESMTP id S261301AbVBRIyg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Feb 2005 03:54:36 -0500
Received: from ruby.patni.com (ruby [204.165.186.9])
	by pcsmail.patni.com (8.12.11/8.12.9) with ESMTP id j1I8tKkW018397
	for <linux-scsi@vger.kernel.org>; Fri, 18 Feb 2005 14:25:23 +0530
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>


In kernel 2.6, I observed that A SCSI device can be echo-removed even if an 
I/O is going on or the device is mounted.
In 2.4 kernels if a SCSI device was mounted or an I/O was going on,echo-remove 
was not possible. In the 2.6 kernels this is no longer true.
Can one give details of the reason for this change

Thanks and Regards
Deepak


