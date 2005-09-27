From: Christoph Hellwig <hch@infradead.org>
Subject: Re: I request inclusion of SAS Transport Layer and AIC-94xx into the kernel
Date: Tue, 27 Sep 2005 14:19:59 +0100
Message-ID: <20050927131959.GA30329@infradead.org>
References: <4339440C.6090107@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:33488 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S964924AbVI0NUE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Sep 2005 09:20:04 -0400
Content-Disposition: inline
In-Reply-To: <4339440C.6090107@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, Sep 27, 2005 at 09:07:24AM -0400, Luben Tuikov wrote:
> P.S. This is a second resend of an identical message
> I posted to lkml and lsml yesterday.

And it's not gotten anymore includable.  Please fix the major structural
issues pointed out when you first sent it out.  That's in the following
order:

 - not trying to integrate with the sas transport class in Linus'
   tree at all, not even using the transport class infrastructure
   at all, creating it's own sysfs trees in rather wierd ways
 - not beeing structures as a library (ala libata which is a very good
   model for it)
 - duplicating the lun scanning code instead of using the scsi core one
