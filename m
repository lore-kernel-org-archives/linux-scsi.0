From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 2/3 ver2] block layer extended-cdb support
Date: Mon, 14 Apr 2008 01:17:09 +0900
Message-ID: <20080414011646S.tomof@acm.org>
References: <47F89948.9060503@panasas.com>
	<20080412145152C.tomof@acm.org>
	<1208095676.4707.6.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:50704 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754146AbYDMQSi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 13 Apr 2008 12:18:38 -0400
In-Reply-To: <1208095676.4707.6.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: fujita.tomonori@lab.ntt.co.jp, bharrosh@panasas.com, jens.axboe@oracle.com, hch@infradead.org, linux-scsi@vger.kernel.org, akpm@linux-foundation.org

On Sun, 13 Apr 2008 09:07:55 -0500
James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> On Sat, 2008-04-12 at 14:52 +0900, FUJITA Tomonori wrote:
> > bsg are created only for scsi devices (and scsi objects like sas host)
> > now. Are there other means to send commands except for ioctl?
> 
> Right now they are ... but the design was to allow for arbitrary packet
> commands (like the frame in/frame out type that SMP needs), so the
> anticipation is that it will be usable by arbitrary packet commands for
> any block conforming device, examples of which would be ide taskfiles,
> raid firmware commands and any other weirder native protocols.  On the
> other hand, this is future work and won't depend on the legacy 16 byte
> cmd size.

Yeah, we could add fc stuff to the list (James Smart said that he
could use bsg in LSF 2007).


> The only block device I know that implements SG_IO is cciss, so perhaps
> there's no need to support a legacy mode at all for large packet
> commands.

I thought that ub supports it too. I'll check the whole tree.
