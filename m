From: Jeff Garzik <jeff@garzik.org>
Subject: Re: Is sata_nv compatible with async scsi scan?
Date: Tue, 21 Apr 2009 06:27:56 -0400
Message-ID: <49ED9FAC.1080303@garzik.org>
References: <49ED6FD7.3070307@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:34849 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751559AbZDUK2F (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Apr 2009 06:28:05 -0400
In-Reply-To: <49ED6FD7.3070307@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Benny Halevy <bhalevy@panasas.com>
Cc: Jeff Garzik <jgarzik@redhat.com>, lkml <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, Arjan van de Ven <arjan@infradead.org>

Benny Halevy wrote:
> Hi Jeff,
> 
> Since 2.6.29 I'm having intermittent problems with booting kernels.
> After supposedly waiting for scsi async scan to complete,
> quite frequently I see errors from the init resume process
> when it fails to find the swap partition and later the root
> file system fails to load.
> 
> A workaround that I found to be helpful is booting the kernel
> with scsi_mod.scan=sync so I suspect sata_nv has a problem
> with asynchronous scanning.

Personally, I think the whole system is broken, so continue to use this 
workaround until it gets fixed upstream.  This sounds like some timing 
issues related to waiting for the device probe to finish, something that 
people keep breaking (witness my USB flash drive boot breakage).

	Jeff



