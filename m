From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 4/8] scsi_dh: Update hp_sw hardware handler
Date: Thu, 17 Jul 2008 18:50:05 -0500
Message-ID: <1216338605.5515.105.camel@localhost.localdomain>
References: <20080717073827.155C018C6FD@pentland.suse.de>
	 <487FD600.1060000@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:46049 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760349AbYGQXuJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Jul 2008 19:50:09 -0400
In-Reply-To: <487FD600.1060000@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org

On Thu, 2008-07-17 at 18:30 -0500, Mike Christie wrote:
> Hannes Reinecke wrote:
> >  	case NOT_READY:
> > -		if ((sshdr.asc == 0x04) && (sshdr.ascq == 3)) {
> > -			rc = SCSI_DH_RETRY;
> > -			h->retries++;
> > +		if ((sshdr.asc == 0x04) && (sshdr.ascq == 2)) {
> 
> I forgot what we decided. Was this supposed to be 2 or 3? If it was 2, 
> then patch looks ok.
> 
> Acked-by: Mike Christie <michaelc@cs.wisc.edu>

Yes, for HP storage it's 2 ... that's initialising command required.

James


