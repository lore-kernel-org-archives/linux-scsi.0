From: Bryan Henderson <hbryan@us.ibm.com>
Subject: Re: remove-single-device removes mounted HDDs (kernel 2.6)
Date: Thu, 11 Aug 2005 10:47:15 -0700
Message-ID: <OFB8A5D53D.2225FFAB-ON8825705A.00611D48-8825705A.0061B7F9@us.ibm.com>
References: <OF8F47C8EA.7E82D4E6-ONC125705A.0053F6D2-C125705A.00567F16@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:63390 "EHLO e2.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S932313AbVHKRrS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Aug 2005 13:47:18 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e2.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id j7BHlDGK012434
	for <linux-scsi@vger.kernel.org>; Thu, 11 Aug 2005 13:47:13 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.12.10/NCO/VERS6.7) with ESMTP id j7BHlDrR204392
	for <linux-scsi@vger.kernel.org>; Thu, 11 Aug 2005 13:47:13 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11/8.13.3) with ESMTP id j7BHlDLY017154
	for <linux-scsi@vger.kernel.org>; Thu, 11 Aug 2005 13:47:13 -0400
Received: from [9.56.227.90] (d01ml604.pok.ibm.com [9.56.227.90])
	by d01av03.pok.ibm.com (8.12.11/8.12.11) with ESMTP id j7BHlDNj017148
	for <linux-scsi@vger.kernel.org>; Thu, 11 Aug 2005 13:47:13 -0400
In-Reply-To: <OF8F47C8EA.7E82D4E6-ONC125705A.0053F6D2-C125705A.00567F16@de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Harald Seipp <SEIPP@de.ibm.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

>Can I rely on the mtab information? I recognized that e.g. submountd will
>add permanent entries even when the devices are not present...
>What about udev, devfsd, usbmount?

Don't use /etc/mtab.  Don't use it for anything if you can help it; it was 
important technology in its day, but we can now go to the horse's mouth -- 
the kernel -- for that information.

/proc/mounts will tell you what is really mounted.

As you mentioned in another posting, this isn't really the information you 
want either -- you want to know if the SCSI disk is in use.  Being the 
device backing a conventional filesystem image is only one way a SCSI disk 
might be in use.

--
Bryan Henderson                     IBM Almaden Research Center
San Jose CA                         Filesystems
