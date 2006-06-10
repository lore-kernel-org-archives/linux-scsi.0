From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] Promise 'stex' driver
Date: Sat, 10 Jun 2006 18:28:03 -0400
Message-ID: <448B4773.2020704@garzik.org>
References: <20060610160852.GA15316@havoc.gtf.org> <20060610170640.GA25118@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:25031 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1161038AbWFJW2F (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 10 Jun 2006 18:28:05 -0400
In-Reply-To: <20060610170640.GA25118@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Jeff Garzik <jeff@garzik.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, akpm@osdl.org, promise_linux@promise.com

Christoph Hellwig wrote:
> I've just posted a patch to kill the last non-sg codepath so this should't
> be needed anymore.

BTW, thanks for this.  This will allow me to kill some libata-scsi code.

	Jeff


