From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 2/2] scsi: wd7000: print sector number as 64-bit
Date: Mon, 20 Jun 2016 21:12:50 -0400
Message-ID: <yq1eg7r5oq5.fsf@sermon.lab.mkp.net>
References: <20160615204231.3784044-1-arnd@arndb.de>
	<4878482.cSGU6mK9NX@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:24217 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491AbcFUBM7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Jun 2016 21:12:59 -0400
In-Reply-To: <4878482.cSGU6mK9NX@wuerfel> (Arnd Bergmann's message of "Wed, 15
	Jun 2016 22:54:49 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-kernel@vger.kernel.org

>>>>> "Arnd" == Arnd Bergmann <arnd@arndb.de> writes:

As sector_t can be 32-bit wide, this adds a cast to 'u64' and prints
that with the correct format. The change to use no_printk()

[...]

+	dprintk("wd7000_biosparam: dev=%s, size=%lld, ",
+		bdevname(bdev, b), (s64)capacity);

s64?

Why not unsigned long long like we usually do with sector_t?

-- 
Martin K. Petersen	Oracle Linux Engineering
