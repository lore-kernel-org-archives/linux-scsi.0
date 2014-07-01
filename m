From: Christoph Hellwig <hch@infradead.org>
Subject: Re: SCSI eats error from flush failure during hot plug
Date: Tue, 1 Jul 2014 01:15:10 -0700
Message-ID: <20140701081510.GA14857@infradead.org>
References: <CAPK7rjcrBuQgoiAxZ9ZASAGugtyHTsHB3ssZegKtuzRdo9TMNQ@mail.gmail.com>
 <20140626150208.GA14887@infradead.org>
 <1403808734.6440.12.camel@dabdike>
 <20140627075553.GB21799@infradead.org>
 <CAPK7rjdpxAALA-oLZJ3wDBPc3kr5Nw4jLALLxEaT0zSiAOD+wg@mail.gmail.com>
 <CAPK7rjcmujziT580t2O_dQnNPn8eyq7CTBxAgbqHYNobZCTxjQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53300 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757376AbaGAIPL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Jul 2014 04:15:11 -0400
Content-Disposition: inline
In-Reply-To: <CAPK7rjcmujziT580t2O_dQnNPn8eyq7CTBxAgbqHYNobZCTxjQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Steven Haber <steven@qumulo.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org

On Mon, Jun 30, 2014 at 11:45:31AM -0700, Steven Haber wrote:
> Our qual rig is having some woes. I'll let you know how the test works
> out after I finish resuscitating it.

Might be worth to test that patch James send in reply then.  They should
have an identical effect and James seems to prefer the version testing
for the length.

