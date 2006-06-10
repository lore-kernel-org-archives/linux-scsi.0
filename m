From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] Promise 'stex' driver
Date: Sat, 10 Jun 2006 12:30:04 -0400
Message-ID: <448AF38C.5030208@garzik.org>
References: <20060610160852.GA15316@havoc.gtf.org> <20060610161036.GA21454@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:10174 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1751597AbWFJQaH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 10 Jun 2006 12:30:07 -0400
In-Reply-To: <20060610161036.GA21454@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, akpm@osdl.org, promise_linux@promise.com

Christoph Hellwig wrote:
> On Sat, Jun 10, 2006 at 12:08:52PM -0400, Jeff Garzik wrote:
>> Please review, and queue in scsi-misc for 2.6.18 if acceptable.
> 
> The driver is not for scsi hardware.  Please implement it as block
> driver.

That's a new requirement.  The interface to the hardware is clearly SCSI.

	Jeff



