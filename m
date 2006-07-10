From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: aic94xx panic on module insertion
Date: Mon, 10 Jul 2006 11:40:28 -0500
Message-ID: <1152549628.7275.24.camel@mulgrave.il.steeleye.com>
References: <1152541373.7275.11.camel@mulgrave.il.steeleye.com>
	 <44B27F74.9000806@torque.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:63132 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1422684AbWGJQkd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Jul 2006 12:40:33 -0400
In-Reply-To: <44B27F74.9000806@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Mon, 2006-07-10 at 12:25 -0400, Douglas Gilbert wrote:
> These comments have no direct bearing on the panic that
> James is reporting, but ... that sequencer version:
> "Razor_10a1" is old and should be updated.
> 
> With a 48300 adapter I needed to do two things:
>   [a] update the board's BIOS firmware from build 1618
>       to 1705 (20060421) [See adaptec's site]
>   [b] update the linux driver's copy of the sequencer
>       code (in my case from Razor_10c2 to Razor_10c5b)
> 
> My card needed [a] to stabilize the POST and device scan
> that the 48300 does prior to the OS loading. Once the

Actually, mine runs with the bios disabled (So I can boot from an SPI
device to , so I won't see this anyway ...

> aic94xx driver is loaded, it replaces the running version
> of the sequencer code with its own copy. If the reader
> sees numerous "tmf timeout" messages in their log then
> there is a good chance old sequencer code is the cause.

And really, this driver needs to use the firmware loader, so this
no-longer becomes an issue.

James


