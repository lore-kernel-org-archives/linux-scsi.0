From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [PATCH] uninline exported ata_host_intr
Date: Fri, 5 Aug 2005 10:30:03 -0700
Message-ID: <20050805173003.GU13374@plap.qlogic.org>
References: <20050805170349.GA6065@suse.de> <42F39DA0.5000208@pobox.com> <20050805171500.GA6161@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:20514 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S263086AbVHERaZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Aug 2005 13:30:25 -0400
Content-Disposition: inline
In-Reply-To: <20050805171500.GA6161@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Olaf Hering <olh@suse.de>
Cc: Jeff Garzik <jgarzik@pobox.com>, Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org

On Fri, 05 Aug 2005, Olaf Hering wrote:

> > When I wrote this, the compiler did what I expected:  it inlined the 
> > local copy, and exported a copy for external modules to call.
> 
> so you have the code twice? how clever...
> 
> > Have you verified the asm does not do this?  What changed?
> 
> I just grepped ^inline below drivers/scsi and found this in qla4xxx and
> libata-core.

Confused, you found a reference to ata_host_intr() in qla4xxx
(QLogic's iSCSI driver)?  This is in a SLES kernel correct, and not in
mainline?

--
av
