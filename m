From: =?iso-8859-1?Q?Strand_=C5ge?= <aage.strand@imr.no>
Subject: aix79xx driver status
Date: Wed, 21 Sep 2005 11:44:28 +0200
Message-ID: <0D54094F69391A438650C6151B0A33E402132A7A@post2.imr.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.imr.no ([82.134.28.194]:24196 "EHLO ns.imr.no")
	by vger.kernel.org with ESMTP id S1750798AbVIUJo3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Sep 2005 05:44:29 -0400
Received: from post2.imr.no ([10.1.2.137])
	by ns.imr.no with esmtp (Exim 4.43)
	id 1EI19Q-00026H-Cw
	for linux-scsi@vger.kernel.org; Wed, 21 Sep 2005 11:44:28 +0200
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Hi,

I'm trying to debug an md RAID problem and was looking into aic79xx driver version, and now I'm confused.

The 2.6.13 kernel code lists the version for this driver as 1.3.11 (AIC79XX_DRIVER_VERSION), and it looks like the last update was back in 2003.

But I can find a 2.0.14 version of the driver at adaptec.com, dated 17.May 2005:
http://www.adaptec.com/worldwide/support/driversbycat.jsp?sess=no&language=English+US&cat=%2FOperating+System%2FLinux+Driver+Source+Code

Granted, it says the driver is "minimally tested", but I wonder why the aic79xx driver in the kernel hasn't been updated since 2003 when there are newer versions being developed by the vendor.

Is there a fork in the aic79xx driver tree? What was the reason? Is there any point in even trying the "minimally tested" driver from adaptec, or is that to be considered dangerous?

I'm having problems with an md RAID running off an Adaptec 39320A-R card (14 disks, one hot spare). I'm getting PKT busfree errors at random intervals which result in RAID disks going offline - so I'm keen to see if a driver update may help. 


Best regards,
Aage Strand
