From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: udf folders pointing to self and above
Date: 29 Sep 2003 16:47:48 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1064875668.3175.9.camel@patehci2>
References: <1064864262.4262.49.camel@patehci2>
	 <1064870151.5458.20.camel@patehci2>
	 <20030929143457.3def59f4.rddunlap@osdl.org>
	 <1064872992.5458.50.camel@patehci2>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:42149 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S263046AbTI2Wra
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Sep 2003 18:47:30 -0400
In-Reply-To: <1064872992.5458.50.camel@patehci2>
List-Id: linux-scsi@vger.kernel.org
To: rddunlap@osdl.org
Cc: linux-scsi@vger.kernel.org

> > Linux filesystems ... in the kernel tree)
> > should be discussed on open mailing lists [such as]
> > linux-fsdevel@vger.kernel.org ...

usb-storage kindly reminds me in part I may have got the idea that we
maintain udf.ko outside of linux-fsdevel by way of kernel.org releasing
2.6.0-test6 Without benefit of the perhaps incorrect patch:

--- linux-2.6.0-test6/MAINTAINERS	2003-09-27 18:50:29.000000000 -0600
+++ linux/MAINTAINERS	2003-09-29 16:44:27.250110640 -0600
@@ -1973,12 +1973,12 @@
 UDF FILESYSTEM
 P:	Ben Fennema
 M:	bfennema@falcon.csc.calpoly.edu
 P:	Dave Boynton
 M:	dave@trylinux.com
-L:	linux_udf@hpesjro.fc.hp.com
-W:	http://linux-udf.sourceforge.net
+L:	linux-fsdevel@vger.kernel.org
+W:	http://www.kernel.org
 S:	Maintained
 
 UMSDOS FILESYSTEM
 P:	Matija Nalis
 M:	Matija Nalis <mnalis-umsdos@voyager.hr>


