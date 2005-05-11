From: Doug Maxey <dwm@maxeymade.com>
Subject: Re: [RFC] mode pages for ATA/ATAPI devices via libata
Date: Wed, 11 May 2005 13:42:17 -0500
Message-ID: <200505111842.j4BIgHY8019500@falcon30.maxeymade.com>
References: <200505111801.j4BI1P5C019280@falcon30.maxeymade.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from falcon30.maxeymade.com ([24.173.215.190]:30597 "EHLO
	falcon30.maxeymade.com") by vger.kernel.org with ESMTP
	id S262017AbVEKSmn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 May 2005 14:42:43 -0400
In-reply-to: <200505111801.j4BI1P5C019280@falcon30.maxeymade.com> 
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Doug Maxey <dwm@maxeymade.com>
Cc: Patrick Mansfield <patmans@us.ibm.com>, Jeff Garzik <jgarzik@pobox.com>, Doug Gilbert <dgilbert@interlog.com>, Albert CC Lee <albertcc@tw.ibm.com>, SCSI development list <linux-scsi@vger.kernel.org>

ahem, the neural pathways are not just worn, they have become ruts. =) 

s/mode/vpd/.

On Wed, 11 May 2005 13:01:25 CDT, Doug Maxey wrote:
>Howdy,
>
>When a ATA/ATAPI device is attached via libata, what should the handling 
>be for mode pages that do not exist in the device?
>
>Assuming the page being asked for is 0x83, should libata fake up the
>page from the IDENTIFY (PACKET) DEVICE data?  Or should it just respond
>there is no page 0x83 as it does now in INQUIRY?  Likewise for 0x80?
>
>++doug
>
>-
>To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


