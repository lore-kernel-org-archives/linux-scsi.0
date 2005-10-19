From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH 1/4] sas: add flag for locally attached PHYs
Date: Wed, 19 Oct 2005 15:37:54 -0400
Message-ID: <4356A092.6060504@adaptec.com>
References: <20051019180117.GB21488@lst.de> <43569D5D.1000801@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:48305 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S1751249AbVJSTiA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Oct 2005 15:38:00 -0400
In-Reply-To: <43569D5D.1000801@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: Christoph Hellwig <hch@lst.de>, jejb@steeleye.com, Eric.Moore@lsil.com, linux-scsi@vger.kernel.org

On 10/19/05 15:24, Luben Tuikov wrote:
> On 10/19/05 14:01, Christoph Hellwig wrote:
> 
>>Add a flag to mark a PHY as attached to the HBA as opposed to beeing on
>>an expander.  This is needed because various features are only supported
>>on those.  This is a crude hack, the proper fix would be to use
>>different classes for host-attached vs expander phys.  I'm looking into
>>that.
> 
> 
> The phy isn't quite "attached" -- i.e. at software level you do not
> care about that.  At least I've never heard anyone (not of "the community")
> say that a phy is "attached".
> 
> You don't need to represent that.  While you can, you completely do not
> need to do it.  All you should care about is the _port_.  Take a look
> at SAS section 4.
> 
> Also take a look at:
> drivers/scsi/sas/sas_phy.c,
> drivers/scsi/sas/sas_port.c and
> drivers/scsi/sas/sas_discover.c .
> 
> Storage GUI applications can read the expander configuration using SMP
> and show this as I've shown in Announcement 1 here:
> http://marc.theaimsgroup.com/?l=linux-scsi&m=112629509826900&w=2

And Announcement 2 (more specifically using the user space configuration
utility program "expander_conf.c"):
http://marc.theaimsgroup.com/?l=linux-scsi&m=112629509318354&w=2

	Luben
-- 
http://linux.adaptec.com/sas/
http://www.adaptec.com/sas/

 
> All you should care about is the _local_ phys since those are
> under your control, and the port formed.
> 
> 	Luben
