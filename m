From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: RE: Hotplug does not work with Fusion MPT
Date: Mon, 15 May 2006 09:04:52 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D700F9E8E@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:21469 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S964916AbWEOPFA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 May 2006 11:05:00 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>, Maik Hampel <Maik.Hampel@xiranet.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Monday, May 15, 2006 7:44 AM, Matthew Wilcox wrote:
> Did you tell Linux you removed it?  Try:
> 
> echo scsi remove-single-device 0 0 4 0 > /proc/scsi/scsi
> 
> Parallel SCSI doesn't have a way to notify the OS that a 
> device is gone,
> so the user has to say.
> 

We have Hotplug device support in fustion drivers for SAS and Fibre, not
for SPI.

Eric Moore
