From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [PATCH 4/7] scsi_dh: Update EMC handler
Date: Fri, 16 May 2008 11:38:40 -0700
Message-ID: <1210963120.21974.336.camel@chandra-ubuntu>
References: <20080514144324.3000410B5DF@craiglockhart-ipmi.suse.de>
	 <1210819629.21974.255.camel@chandra-ubuntu>  <482BEFAC.7030400@suse.de>
Reply-To: sekharan@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:60993 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755849AbYEPSgy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 16 May 2008 14:36:54 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e33.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m4GIaslF012532
	for <linux-scsi@vger.kernel.org>; Fri, 16 May 2008 14:36:54 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m4GIar5L101908
	for <linux-scsi@vger.kernel.org>; Fri, 16 May 2008 12:36:53 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m4GIapUP005982
	for <linux-scsi@vger.kernel.org>; Fri, 16 May 2008 12:36:53 -0600
In-Reply-To: <482BEFAC.7030400@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, dm-devel <dm-devel@redhat.com>


On Thu, 2008-05-15 at 10:09 +0200, Hannes Reinecke wrote:
> Hi Chandra,
> 
> Chandra Seetharaman wrote:
> > On Wed, 2008-05-14 at 16:43 +0200, Hannes Reinecke wrote:
> > <snip>
> > 
> >> @@ -438,10 +604,32 @@ static int clariion_bus_attach(struct scsi_device *sdev)
> >>  	sdev->scsi_dh_data = scsi_dh_data;
> >>  	spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
> >>
> > Can move the block above to be just before try_module_get() and avoid
> > undoing it in the failed path.
> > 
> Hmm. Yes, we could. But that means I have to pass the scsi_dh_data structure
> to basically every function.
> Let me check how this pans out.

Yeah, it is a catch-22 problem. I will think about it too.

> 
> Cheers,
> 
> Hannes

