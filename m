From: "Mukker, Atul" <atulm@lsil.com>
Subject: RE: [ANNOUNCE] megaraid linux driver version 2.00.7
Date: Tue, 5 Aug 2003 18:09:10 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E570185F3FA@EXA-ATLANTA.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:57522 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S272920AbTHEXWc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Aug 2003 19:22:32 -0400
List-Id: linux-scsi@vger.kernel.org
To: 'Christoph Hellwig' <hch@infradead.org>
Cc: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, "'linux-megaraid-devel@dell.com'" <linux-megaraid-devel@dell.com>

> +	spin_lock_irqsave(adapter->host->host_lock, flags);
But all kernels do not have this lock as part of the host structure. With
2.00.7, I have relapsed a patch which switches the lock to io_request_lock
if kernel does not support per host lock.

And not all kernels have the per host lock named as "host->host_lock", some
simply have "host->lock"

-Atul Mukker
