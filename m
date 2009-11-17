From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH V2] libata: add TRIM support
Date: Tue, 17 Nov 2009 17:01:19 -0500
Message-ID: <4B031D2F.7030004@pobox.com>
References: <20091117150047.GB10748@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:48782 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751999AbZKQWBe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Nov 2009 17:01:34 -0500
In-Reply-To: <20091117150047.GB10748@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, "Martin K. Petersen" <mkp@mkp.net>, Matthew Wilcox <willy@wil.cx>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Mark Lord <liml@rtr.ca>

On 11/17/2009 10:00 AM, Christoph Hellwig wrote:
> Add support for the ATA TRIM command in libata.  We translate a WRITE SAME 16
> command with the unmap bit set into an ATA TRIM command and export enough
> information in READ CAPACITY 16 and the block limits EVPD page so that the new
> SCSI layer discard support will driver this for us.
>
> Note that I hardcode the WRITE_SAME_16 opcode for now as the patch to introduce
> the symbolic is not in 2.6.32 yet but only in the SCSI tree - as soon as it is
> merged we can fix it up to properly use the symbolic name.
>
> Signed-off-by: Christoph Hellwig<hch@lst.de>

Looks good to me....  will apply to libata-dev.git#upstream soonish

	Jeff




