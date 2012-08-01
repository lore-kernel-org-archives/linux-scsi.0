From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: SCSI disk IO problem with JBOD
Date: Wed, 01 Aug 2012 00:11:45 -0500
Message-ID: <5018BA91.3000506@hardwarefreak.com>
References: <5018A9EF.2080003@soe.ucsc.edu>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo-65-41-216-221.sta.embarqhsd.net ([65.41.216.221]:44115 "EHLO
	greer.hardwarefreak.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753159Ab2HAFS5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Aug 2012 01:18:57 -0400
In-Reply-To: <5018A9EF.2080003@soe.ucsc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Erich Weiler <weiler@soe.ucsc.edu>
Cc: linux-scsi@vger.kernel.org

On 7/31/2012 11:00 PM, Erich Weiler wrote:
> Hi Y'all,
> 
> First let me apologize if this is the wrong venue to post this question.
>  If it is not, please point me to the correct spot if possible!
> 
> We have a Dell R610 server running CentOS 6.3 (kernel
> 2.6.32-279.2.1.el6.x86_64).  We installed a LSI 9201-16e SAS HBA in it,
> upgraded to the latest firmware (9116 chipset).  Then we attached a LSI
> DE2660 JBOD array to it, with 60 hard drives.

TTBOMK LSI never made a 60 drive JBOD chassis.  Is this actually 3x 24
bay JBOD chassis daisy chained?  Did you buy them on Ebay or are these
simply being redeployed?  All LSI drive chassis, both JBOD and SAN/DAS
RAID, have been discontinued for quite a while.

First remove and re-seat all SFF8088 cables.  Then replace them one by
one until the errors/problems are eliminated.  If not test each chassis
expander module individually with only one in the chassis.  Test it in
both module bays.  Basic process of elimination stuff.

Given you're receiving errors on multiple drives I'd say you have a bad:

1.  Cable
2.  Backplane
3.  Expander module
4.  PSU

-- 
Stan

