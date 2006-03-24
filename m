From: Stephen Degler <stephen@degler.net>
Subject: Re: scsi negotiation problem on aic79xx (39320A) in 2.6.14
Date: Fri, 24 Mar 2006 13:05:43 -0500
Message-ID: <442434F7.1070804@degler.net>
References: <20051114224512.GF9905@mathom.us> <20060323180909.GD15140@mathom.us> <1143139044.3415.26.camel@mulgrave.il.steeleye.com> <20060324122715.GG15140@mathom.us> <4423E65E.20005@suse.de> <20060324123229.GH15140@mathom.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from crusoe.degler.net ([66.114.64.229]:17915 "EHLO
	crusoe.degler.net") by vger.kernel.org with ESMTP id S1751293AbWCXSGE
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Mar 2006 13:06:04 -0500
In-Reply-To: <20060324123229.GH15140@mathom.us>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Stone <mstone@mathom.us>
Cc: Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org

Note that Hannes' patch specific to observing the bios defaults applies 
cleanly to 2.6.14.x mainline.

skd

Michael Stone wrote:

> On Fri, Mar 24, 2006 at 01:30:22PM +0100, Hannes Reinecke wrote:
>
>> Well, yes. You can limit the transfer speed in the BIOS for that device.
>> With the latest patches from scsi-misc we're finally picking them up :-)
>
>
> I actually thought I had done that at one point when I was testing, 
> but I'll double check next time I reboot at the console.
>
> Mike Stone
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

