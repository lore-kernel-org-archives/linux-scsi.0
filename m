From: 'Christoph Hellwig' <hch@infradead.org>
Subject: Re: [ANNOUNCE] megaraid linux driver version 2.00.7
Date: Wed, 6 Aug 2003 06:43:53 +0100
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20030806064353.A21769@infradead.org>
References: <0E3FA95632D6D047BA649F95DAB60E570185F3FA@EXA-ATLANTA.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E570185F3FA@EXA-ATLANTA.se.lsil.com>; from atulm@lsil.com on Tue, Aug 05, 2003 at 06:09:10PM -0400
To: "Mukker, Atul" <atulm@lsil.com>
Cc: 'Christoph Hellwig' <hch@infradead.org>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, "'linux-megaraid-devel@dell.com'" <linux-megaraid-devel@dell.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Aug 05, 2003 at 06:09:10PM -0400, Mukker, Atul wrote:
> > +	spin_lock_irqsave(adapter->host->host_lock, flags);
> But all kernels do not have this lock as part of the host structure. With
> 2.00.7, I have relapsed a patch which switches the lock to io_request_lock
> if kernel does not support per host lock.
> 
> And not all kernels have the per host lock named as "host->host_lock", some
> simply have "host->lock"A

All 2.5/2.6 kernels do have host->host_lock and the 2.5 driver is different
from the 2.4 one.  In fact it will hopefuloly become &host->host_lock soon
but for that I have to repair the remaining abusers first.
