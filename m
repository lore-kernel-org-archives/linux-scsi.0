From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Qlogic ISP 1020
Date: Thu, 21 Oct 2004 10:11:16 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041021091116.GA2130@infradead.org>
References: <1080004793.5848.34.camel@localhost> <20040323062912.B29405@infradead.org> <1080075653.2457.11.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([81.187.226.98]:57865 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S268819AbUJUJLY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Oct 2004 05:11:24 -0400
Content-Disposition: inline
In-Reply-To: <1080075653.2457.11.camel@localhost>
List-Id: linux-scsi@vger.kernel.org
To: Jeff Layton <jtlayton@poochiereds.net>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

On Tue, Mar 23, 2004 at 04:00:53PM -0500, Jeff Layton wrote:
> On Tue, 2004-03-23 at 01:29, Christoph Hellwig wrote:
> > https://verein.lst.de/~hch/qla1280-isp1040.diff.bz2 has my current patch.
> > 
> > So far I only kno it works with 1040B's on SGI Origins.   If you want to
> > give it a try apply the patch and make sure you have the qla1280 but not the
> > qlogicisp driver in the kernel.
> > 
> > I'll try to split the patch into reasoable chunk soon and feed it to Jes.
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> I tried this out today, and the results were mixed. Here's the lspci
> output for this card:

In current mainline the qla1280 driver supports the 1020 now.  Care to test
again?  I've heard success reports for both i386 and alpha so far.

