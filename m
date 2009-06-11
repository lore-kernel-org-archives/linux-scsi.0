From: "Srinivas G." <srinivasg@esntechnologies.co.in>
Subject: NOT able to get the debug statements (printk) from SCSI modules
Date: Thu, 11 Jun 2009 13:03:49 +0530
Message-ID: <F5BA82141F7AA94885B9643C77EEA5F21A3EB2@mail.esntechnologies.co.in>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [220.227.243.42] ([220.227.243.42]:1380 "EHLO
	mail.esntechnologies.co.in" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1763730AbZFQK3C convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Jun 2009 06:29:02 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Dear All,

I brief, my question is, how can I get the debug messages from SCSI
files like hosts.c, scsi.c etc. I have added some printk statements
explicitly. These files are existing in the
/usr/src/kernels/linux-2.6.28/drivers/scsi directory.

The module name is scsi_mod.ko.

I have modified the .config through make menuconfig to build the
scsi_mod as a module.

Any suggestions will be greatly appreciated.

Thanks and Regards,
Srinivas G

