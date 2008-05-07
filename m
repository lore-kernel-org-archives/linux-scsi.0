From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [PATCH 0/3] Update scsi_dh infrastructure
Date: Wed, 07 May 2008 11:45:59 -0700
Message-ID: <1210185959.21974.136.camel@chandra-ubuntu>
References: <4821C4C1.2010602@suse.de>
Reply-To: sekharan@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:50741 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755952AbYEGSol (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 May 2008 14:44:41 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e1.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m47IieXX010140
	for <linux-scsi@vger.kernel.org>; Wed, 7 May 2008 14:44:40 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m47Iie9j252540
	for <linux-scsi@vger.kernel.org>; Wed, 7 May 2008 14:44:40 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m47Iid2C011705
	for <linux-scsi@vger.kernel.org>; Wed, 7 May 2008 14:44:40 -0400
In-Reply-To: <4821C4C1.2010602@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, dm-devel <dm-devel@redhat.com>

Hannes,

I do not see the patch :)

chandra

On Wed, 2008-05-07 at 17:03 +0200, Hannes Reinecke wrote:
> Hi Chandra,
> 
> this patchset updates the scsi_dh infrastructure as laid out
> in my previous mail. In particular it does
> 
> - update the scsi_dh infrastructure to implement a generic
>   device table handling; the static device tables from the
>   individual handlers are copied into a generic list.
>   This allows us to do the checking in the main scsi_dh
>   module instead of having to implement it for every handler.
>   And we can then modify this list dynamically
> - Implements a 'dh_state' attribute for the sdev, which
>   allows for manipulating of the device handler itself.
>   So we can now attach, detach, and activate any device
>   handler manually.
> - And finally I've updated my SPC-3 alua handler for the
>   new infrastructure. Please include it in your patchset, too.
> 
> Patches are relative to your latest patchset.
> 
> Cheers,
> 
> Hannes

