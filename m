From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Next March 25: Boot failure on powerpc [recursive locking
	detected]
Date: Thu, 26 Mar 2009 08:50:03 -0500
Message-ID: <1238075403.3342.1.camel@localhost.localdomain>
References: <20090325191229.0e17eaf6.sfr@canb.auug.org.au>
	 <49CA3BF4.3050801@in.ibm.com>  <49CB2200.50703@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:48014 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757663AbZCZNuH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Mar 2009 09:50:07 -0400
In-Reply-To: <49CB2200.50703@in.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sachin Sant <sachinp@in.ibm.com>
Cc: linuxppc-dev@ozlabs.org, Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>

On Thu, 2009-03-26 at 12:04 +0530, Sachin Sant wrote:
> Sachin Sant wrote:
> > Today's next failed to boot on a powerpc box
> > (Power6 blade IBM,7998-61X) with following recursive locking message.
> >
> > =============================================
> > [ INFO: possible recursive locking detected ]
> > 2.6.29-next-20090325 #1
> After bisecting the failure seems to be because of the following
> patch from James ( block: move SCSI timeout check into block )
> 
> http://patchwork.kernel.org/patch/8017/
> 
> If i back out the above mentioned patch, the machine boots fine
> without any problems.

Yes, that patch already got dropped for other reasons:

http://marc.info/?t=123740773700002

I'm going to see if I can redo it in a better way, since moving this
type of timeout checking from scsi to block is a useful generalisation.

James


