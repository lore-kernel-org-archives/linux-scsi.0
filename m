From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH]: Flexible timeout infrastructure
Date: Tue, 15 Jun 2004 16:42:23 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040615154223.GA13780@infradead.org>
References: <40CF0F9F.4050902@adaptec.com> <1087313241.2710.40.camel@laptop.fenrus.com> <40CF1852.6030306@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [213.146.154.40] ([213.146.154.40]:14830 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S265695AbUFOPm0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Jun 2004 11:42:26 -0400
Content-Disposition: inline
In-Reply-To: <40CF1852.6030306@adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: arjanv@redhat.com, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, Jun 15, 2004 at 11:40:02AM -0400, Luben Tuikov wrote:
> >to me it somewhat sounds like the wrong approach.
> >I'm all for the LLDD to be able to influence the timeout value, but I
> >consider it a bad mistake to make every driver reinvent timeout
> >*handling*.
> 
> This has very little to do with the timeout _value_, and it has
> all to do with *recovery* which is a beast on its own as far as transport
> protocols are concerned, especially over non-native interconnects (iSCSI, 
> USB,
> RDMA). I believe I did mention this at the end of the text.
> (mea culpa it was kind of a long text) 

That's why the plan is to move it into the transport class slowly.  Remeber
there are much more SPI drivers than just aic7xxx/aic79xx ;-)

