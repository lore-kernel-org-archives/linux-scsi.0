From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH]: Flexible timeout infrastructure
Date: Tue, 15 Jun 2004 11:46:08 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40CF19C0.5080507@adaptec.com>
References: <40CF0F9F.4050902@adaptec.com> <1087313241.2710.40.camel@laptop.fenrus.com> <40CF1852.6030306@adaptec.com> <20040615154223.GA13780@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:48574 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S265706AbUFOPqK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Jun 2004 11:46:10 -0400
In-Reply-To: <20040615154223.GA13780@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: arjanv@redhat.com, SCSI Mailing List <linux-scsi@vger.kernel.org>

> That's why the plan is to move it into the transport class slowly.  Remeber
> there are much more SPI drivers than just aic7xxx/aic79xx ;-)

Yes, in which case it would look like FreeBSD.  Then SCSI Core will
have to implement _all_ transports it wants to support (a la USB Storage).

But if we *do* allow for this patch, then _moving_ this functionality
into the transport class recovery would be really easy.  Just move
eh_cmd_timed_out() into the transport class.

-- 
Luben


