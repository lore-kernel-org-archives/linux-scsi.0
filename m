From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] Promise 'stex' driver
Date: Sat, 10 Jun 2006 13:37:38 -0400
Message-ID: <448B0362.8030901@garzik.org>
References: <20060610160852.GA15316@havoc.gtf.org> <20060610170640.GA25118@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:29376 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1751664AbWFJRhk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 10 Jun 2006 13:37:40 -0400
In-Reply-To: <20060610170640.GA25118@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, akpm@osdl.org, promise_linux@promise.com

Thanks, just did several of these and checked it into 'stex' branch.

commit 1b6f2a81e789ebef27107765656d425ab44a2f44
Author: Jeff Garzik <jeff@garzik.org>
Date:   Sat Jun 10 13:36:54 2006 -0400

     [SCSI] stex: minor cleanups

     - fix endian bug found in s/g code (used a fixed-endian value
       as a loop-terminating variable)

     From a list of changes suggested by Christoph:

     - don't include linux/config.h
     - whitespace fix
     - let compiler choose whether or not to inline
     - eliminate unnecessary NULL test on hba->dma_mem
     - handle pci_map_sg() error

