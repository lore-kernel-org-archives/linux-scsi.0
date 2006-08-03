From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: RE: Performance Problem with LSI Logic 53c1030 RAID
Date: Thu, 3 Aug 2006 12:06:51 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D7026B967@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:52352 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1751378AbWHCSGy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Aug 2006 14:06:54 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Scott Lowrey <slowrey@nextone.com>, linux-scsi@vger.kernel.org

-- On Thursday, August 03, 2006 11:50 AM, Scott Lowrey wrote:
> 
> Problem: 
>       Deteriorating disk write performance with large files.  
>       
>       The problem *disappears* completely if RAID is disabled 
> or if the
> array
>       is put into a degraded state by pulling the secondary 
> array drive.
> The
>       problem *remains* if the primary array drive is pulled.
> 


Is it possible for you to upgrade to the latest stable kernel on
www.kernel.org, such as 2.6.17, or even 2.6.18-rc3.  This issue would
be solved.  I believe one of your disks in your integrated volume
is running asyn narrow, due to a bug in the driver.  From 2.6.17 kernel,
the mptspi driver is using the spi transport layer.

Eric Moore
LSI Logic 
