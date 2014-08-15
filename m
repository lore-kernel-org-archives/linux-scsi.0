From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [ANNOUNCE] scsi patch queue tree updated
Date: Fri, 15 Aug 2014 12:32:04 -0700
Message-ID: <1408131124.11617.25.camel@HansenPartnership.com>
References: <20140708134003.GA7790@infradead.org>
	 <20140801122042.GA10771@infradead.org> <1406925121.2654.21.camel@jarvis>
	 <20140804111147.GA29148@infradead.org> <1407162004.4243.1.camel@jarvis.lan>
	 <20140814125451.GA832@infradead.org> <1408038428.2066.42.camel@jarvis.lan>
	 <20140815192505.GA25198@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:55873 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751138AbaHOTcH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Aug 2014 15:32:07 -0400
In-Reply-To: <20140815192505.GA25198@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>

On Fri, 2014-08-15 at 12:25 -0700, Christoph Hellwig wrote:
> On Thu, Aug 14, 2014 at 10:47:08AM -0700, James Bottomley wrote:
> > So this is a bit late to get through linux-next and into a pull request.
> > I was planning on sending the final pull tomorrow (in case Linus planned
> > a surprise early release).  Can we redo some of these as bug fixes and
> > send them in for -rc1?
> 
> core-for-3.17 is entirely bug fixes, the drivers side is all except
> for 4 tiny patches, and even Linus isn't that anal I think.

You rebased the tree before doing it ... that's the one thing that
excites his process gene.  I can't send a rebased tree in on the last
day of merging.

I'll send in the unrebased tree which has been sitting in linux-next for
the past week.  The two additional changes in core-for-3.17 can be
picked out and sent as eligible bug fixes for -rc1.  The only addition
in drivers-for-3.17 is eata: remove driver_lock ... I'm in two minds
about whether we treat that as a bug fix or not.

James


