From: Christoph Hellwig <hch@infradead.org>
Subject: Re: SCSI eats error from flush failure during hot plug
Date: Thu, 10 Jul 2014 00:44:53 -0700
Message-ID: <20140710074453.GA1631@infradead.org>
References: <CAPK7rjcrBuQgoiAxZ9ZASAGugtyHTsHB3ssZegKtuzRdo9TMNQ@mail.gmail.com>
 <20140626150208.GA14887@infradead.org>
 <1403808734.6440.12.camel@dabdike>
 <20140627075553.GB21799@infradead.org>
 <CAPK7rjdpxAALA-oLZJ3wDBPc3kr5Nw4jLALLxEaT0zSiAOD+wg@mail.gmail.com>
 <CAPK7rjcmujziT580t2O_dQnNPn8eyq7CTBxAgbqHYNobZCTxjQ@mail.gmail.com>
 <20140701081510.GA14857@infradead.org>
 <CAPK7rjdVM-Anw-uFc6RGCrwZko885vBGgbB+LehmuKF4r6nu5A@mail.gmail.com>
 <20140703171807.GA20300@infradead.org>
 <1404945498.2184.10.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59071 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645AbaGJHoy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jul 2014 03:44:54 -0400
Content-Disposition: inline
In-Reply-To: <1404945498.2184.10.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@infradead.org>, Steven Haber <steven@qumulo.com>, linux-scsi@vger.kernel.org

On Wed, Jul 09, 2014 at 03:38:18PM -0700, James Bottomley wrote:
> On Thu, 2014-07-03 at 10:18 -0700, Christoph Hellwig wrote:
> > On Thu, Jul 03, 2014 at 09:57:32AM -0700, Steven Haber wrote:
> > > Both patches work fine -- zero uncommitted writes over several hundred
> > > power cycles.
> > 
> > Thanks for the testing.
> > 
> > Below is James' patch with a trivial comment fix and a proper changelog.
> > James, can I get your signoff for this one?  I'll throw it into the
> > core-for-3.16 tree then.
> 
> OK, here it is.  I tweaked the comment to be accurate.

Thanks.  Can someone give me a second review for it as well?

