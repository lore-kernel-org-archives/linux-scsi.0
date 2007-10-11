From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: drivers/fc4/fc.c in git-scsi-misc
Date: Thu, 11 Oct 2007 13:05:32 +0200
Message-ID: <470E037C.4080204@panasas.com>
References: <20071011025203.e95690ee.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:10570 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754552AbXJKLFq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Oct 2007 07:05:46 -0400
In-Reply-To: <20071011025203.e95690ee.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>

On Thu, Oct 11 2007 at 11:52 +0200, Andrew Morton <akpm@linux-foundation.org> wrote:
> davem won't be happy
> 
> drivers/fc4/fc.c: In function `fcp_scsi_receive':
> drivers/fc4/fc.c:397: error: structure has no member named `done'
> drivers/fc4/fc.c:450: error: structure has no member named `done'
> drivers/fc4/fc.c: In function `fcp_scsi_queuecommand':
> drivers/fc4/fc.c:837: error: structure has no member named `done'
> drivers/fc4/fc.c:838: error: structure has no member named `done'
> drivers/fc4/fc.c:839: error: structure has no member named `done'
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

OK that was a nice lesson in Kconfig and Linux-Makefile for me :)

So I can see that drivers/fc4/Kconfig is only "source"d from 
arch/sparc64/Kconfig. Hence no one experienced the breakage.

[
If I add to, say, drivrs/Kconfig
+source drivers/fc4/Kconfig
Than everything compiles and I can see the breakage now
]

Do you have a cross-compiling environment to compile all these
ARCHs, or you actually have these machines laying around for
compilation. (It's the cross-compiling I'm interested in)

Thanks
Boaz
