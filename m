From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] QStor SATA/RAID driver for 2.6.9-rc3
Date: Thu, 07 Oct 2004 11:50:51 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <416565DB.4050006@pobox.com>
References: <4161A06D.8010601@rtr.ca> <416547B6.5080505@rtr.ca> <20041007150709.B12688@infradead.org> <4165624C.5060405@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:56467 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S267410AbUJGPvK
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Oct 2004 11:51:10 -0400
In-Reply-To: <4165624C.5060405@rtr.ca>
List-Id: linux-scsi@vger.kernel.org
To: Mark Lord <lkml@rtr.ca>
Cc: Christoph Hellwig <hch@infradead.org>, Linux Kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

Mark Lord wrote:
> And the EXPORT_SYMBOLS() have not been vetoed to my knowledge.
> They're required for addtional driver extensions that are being
> provided later one, as GPL'd source code.

Yes, they have been vetoed :)  I explicitly used the word 'vetoed' in fact.

You can add the hooks when you add code to the kernel that uses them.

We don't add hooks on the _hope_ that _future_ code will (a) use the 
hooks and (b) be GPL'd.

	Jeff


