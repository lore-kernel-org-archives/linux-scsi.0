From: Olaf Hering <olh@suse.de>
Subject: Re: [PATCH] uninline exported ata_host_intr
Date: Fri, 5 Aug 2005 19:15:00 +0200
Message-ID: <20050805171500.GA6161@suse.de>
References: <20050805170349.GA6065@suse.de> <42F39DA0.5000208@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.suse.de ([195.135.220.2]:41141 "EHLO mx1.suse.de")
	by vger.kernel.org with ESMTP id S262979AbVHERPE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Aug 2005 13:15:04 -0400
Content-Disposition: inline
In-Reply-To: <42F39DA0.5000208@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org

 On Fri, Aug 05, Jeff Garzik wrote:

> When I wrote this, the compiler did what I expected:  it inlined the 
> local copy, and exported a copy for external modules to call.

so you have the code twice? how clever...

> Have you verified the asm does not do this?  What changed?

I just grepped ^inline below drivers/scsi and found this in qla4xxx and
libata-core.
