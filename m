From: Andrew Vasquez <praka@users.sourceforge.net>
Subject: Re: PATCH [14/18] qla2xxx: Use proper include files
Date: Tue, 22 Jun 2004 10:49:00 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040622174900.GA14887@praka.san.rr.com>
References: <B179AE41C1147041AA1121F44614F0B0DD027D@AVEXCH02.qlogic.org> <20040622172207.GB6074@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-01-qfe0.socal.rr.com ([66.75.162.133]:57282 "EHLO
	ms-smtp-01-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S265084AbUFVSAR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Jun 2004 14:00:17 -0400
Content-Disposition: inline
In-Reply-To: <20040622172207.GB6074@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>

On Tue, 22 Jun 2004, Christoph Hellwig wrote:
> > +/*
> > +* String arrays
> > +*/
> > +#define LINESIZE    256
> > +#define MAXARGS      26
> 
> IIRC these weren't actually used anywhere.
> 

Yes, in the embedded (non-failover) driver the defines are unused.
I'll do some additional cleanup in the used areas and followup with a
scrubbing patch during our next code drop.

In the interim, James, please apply the ACKd patch.

Thanks,
Andrew Vasquez
