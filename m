From: 'Christoph Hellwig' <hch@infradead.org>
Subject: Re: [ANNOUNCE]: megaraid driver version 2.20.0.rc2
Date: Wed, 23 Jun 2004 21:48:20 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040623204820.GA29920@infradead.org>
References: <0E3FA95632D6D047BA649F95DAB60E57033BC694@exa-atlanta> <20040528140238.GA28249@infradead.org> <20040623203350.GA29538@infradead.org> <40D9EB36.7040806@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [213.146.154.40] ([213.146.154.40]:19356 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S262007AbUFWUs0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Jun 2004 16:48:26 -0400
Content-Disposition: inline
In-Reply-To: <40D9EB36.7040806@pobox.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: 'Christoph Hellwig' <hch@infradead.org>, "Mukker, Atul" <Atulm@lsil.com>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

On Wed, Jun 23, 2004 at 04:42:30PM -0400, Jeff Garzik wrote:
> 'Christoph Hellwig' wrote:
> >>- any chance to rework megaraid_mbox.c to need less forward-declarations
> >>  by reordering the function in their natural order?
> >
> >
> >still quite a lot of those.
> 
> This is maintainer's choice, and is _not_ a requirement for merging.

Read the request, it's certainly not written as a hard requirement, but
I ask every maintainer nicely for it anyway.

