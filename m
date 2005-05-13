From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [RFC] mode pages for ATA/ATAPI devices via libata
Date: Fri, 13 May 2005 13:06:10 -0400
Message-ID: <4284DE82.7020808@pobox.com>
References: <200505111801.j4BI1P5C019280@falcon30.maxeymade.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:56789 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S262435AbVEMRG2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 May 2005 13:06:28 -0400
In-Reply-To: <200505111801.j4BI1P5C019280@falcon30.maxeymade.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Doug Maxey <dwm@maxeymade.com>
Cc: Patrick Mansfield <patmans@us.ibm.com>, Doug Gilbert <dgilbert@interlog.com>, Albert CC Lee <albertcc@tw.ibm.com>, SCSI development list <linux-scsi@vger.kernel.org>

Doug Maxey wrote:
> Howdy,
> 
> When a ATA/ATAPI device is attached via libata, what should the handling 
> be for mode pages that do not exist in the device?
> 
> Assuming the page being asked for is 0x83, should libata fake up the
> page from the IDENTIFY (PACKET) DEVICE data?  Or should it just respond
> there is no page 0x83 as it does now in INQUIRY?  Likewise for 0x80?

For ATA, it should be emulated according to T10 SCT.

For ATAPI, it should be passed through to the device in almost all 
cases.  I'm not terribly interested even in adding support for the T10 
SCT-suggested stuff for ATAPI.

	Jeff



