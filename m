From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [ANNOUNCE] scsi patch queue tree updated
Date: Tue, 16 Sep 2014 22:44:42 +0100
Message-ID: <1410903882.3840.17.camel@jarvis>
References: <20140708134003.GA7790@infradead.org>
	 <20140801122042.GA10771@infradead.org>
	 <20140915225818.GA11869@infradead.org>
	 <20140916213739.GA19111@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:41370 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753033AbaIPVos (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Sep 2014 17:44:48 -0400
In-Reply-To: <20140916213739.GA19111@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, 2014-09-16 at 14:37 -0700, Christoph Hellwig wrote:
> On Mon, Sep 15, 2014 at 03:58:18PM -0700, Christoph Hellwig wrote:
> > I've pushed two updates to the core-for-3.17 branch of
> > 
> >     git://git.infradead.org/users/hch/scsi-queue.git
> > 
> > which should go to Linus before the next rc.
> > 
> > One is a regression fix for drivers using block layer tagging when
> > not using blk-mq introduced in the blk-mq series, and the other
> > fixes a potential buffer overrun in the iscsi initiator.
> > 
> > Updates of the for-3.18 trees will follow soon.
> 
> core-for-3.17 has grown another fix from Daniel for bidi support.

OK, I've pushed this to -next.  If nothing bad turns up I'll send it to
Linus on Friday.

James


