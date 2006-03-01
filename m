From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: SATA on mptsas performance
Date: Wed, 01 Mar 2006 01:09:18 -0500
Message-ID: <44053A8E.6000206@pobox.com>
References: <F331B95B72AFFB4B87467BE1C8E9CF5F28A5FF@NAMAIL2.ad.lsil.com> <43F2DDA7.7050700@web.de> <44051548.9090408@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:9639 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S932364AbWCAGJX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Mar 2006 01:09:23 -0500
In-Reply-To: <44051548.9090408@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: Mirko Benz <mirko.benz@web.de>, linux-scsi@vger.kernel.org

Douglas Gilbert wrote:
> If the SATA disk does 3 Gb/sec then yes but SATA-1 disks
> run at 1.5 Gb/sec (and don't have NCQ). When a SAS HBA

To further confuse things, "SATA-1", "SATA-2", etc. don't mean much at 
all.  I recommend never using these terms.

There are many disks that can do NCQ but not 3 Gb/sec, for example.

Its best just to mention the existence of features, because there is no 
__technical__ definition of "SATA 2" that one can test in software. 
SATA 2 is just a set of features defined by marketing.

	Jeff

