From: christophe varoqui <christophe.varoqui@free.fr>
Subject: Re: LUN resizing
Date: Fri, 28 Nov 2003 23:29:19 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1070058559.7265.79.camel@zezette>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp8.wanadoo.fr ([193.252.22.23]:48321 "EHLO
	mwinf0803.wanadoo.fr") by vger.kernel.org with ESMTP
	id S263510AbTK1W3X (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Nov 2003 17:29:23 -0500
Received: from AAmiens-106-1-30-29.w81-248.abo.wanadoo.fr (AAmiens-106-1-30-29.w81-248.abo.wanadoo.fr [81.248.163.29])
	by mwinf0803.wanadoo.fr (SMTP Server) with ESMTP id EE2C718000E8
	for <linux-scsi@vger.kernel.org>; Fri, 28 Nov 2003 23:29:21 +0100 (CET)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org



> The problem you are trying to solve has three components:
> 
> 1. Filesystem resize
> 2. parition resize
> 3. SCSI device resize
> 
> 1 and 3 are solved (for a subset of fs).  A solution to 2 is to use the
> Linux device mapper (a mini volume manager) to replace the use of
> gendisk partitions.  Then your entire stack constructed this way will be
> resizable.

Yes, this idea is floating around :
See the dmpartx post covered at http://lwn.net/Articles/13958/

May be someone (Andries B) will get something like that in initramfs for
2.7 ...

regards,
cvaroqui

