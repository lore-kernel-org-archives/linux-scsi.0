From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] uninline exported ata_host_intr
Date: Fri, 05 Aug 2005 13:44:34 -0400
Message-ID: <42F3A582.8050800@pobox.com>
References: <20050805170349.GA6065@suse.de> <42F39DA0.5000208@pobox.com> <20050805171500.GA6161@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:49803 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S262777AbVHERoq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Aug 2005 13:44:46 -0400
In-Reply-To: <20050805171500.GA6161@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Olaf Hering <olh@suse.de>
Cc: Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org

Olaf Hering wrote:
>  On Fri, Aug 05, Jeff Garzik wrote:
> 
> 
>>When I wrote this, the compiler did what I expected:  it inlined the 
>>local copy, and exported a copy for external modules to call.
> 
> 
> so you have the code twice? how clever...

This is one of the key hot paths in the driver.

Considering that drivers either call one copy, or the other, the 
tradeoff is minor overall code size increase for performance gains. 
This is a typical tradeoff in hot paths.

The code stays until you prove otherwise...

	Jeff


