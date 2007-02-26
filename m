From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: Please help if u can.
Date: Mon, 26 Feb 2007 15:20:52 -0800 (PST)
Message-ID: <65760.78889.qm@web31811.mail.mud.yahoo.com>
References: <45DB9D89.7030804@tlchosting.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31811.mail.mud.yahoo.com ([68.142.207.74]:38749 "HELO
	web31811.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1161399AbXBZXUx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Feb 2007 18:20:53 -0500
In-Reply-To: <45DB9D89.7030804@tlchosting.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Scarpa <john@tlchosting.com>, linux-scsi@vger.kernel.org

--- John Scarpa <john@tlchosting.com> wrote:
> Dear Luben,
> 
> I am trying to compile the aic94xx for my aic9410 directly into my 
> kernel (fc5_64bit-2.6.20)...  Is this possible or must it be loaded as a 
> module?  I am really not wanting to add modular support to my nice neat 
> monolithic kernel.. :-(  I've been searching for ever now and tried 
> everything i could to no avail..

Dear John,

The driver which you found in the kernel was forked off of my
main development git tree, by bottomley, changed privately by him
and then committed to the kernel.  It is loosely maintained by
him and linux-scsi.

The driver which I maintain keeps the FW code as u8[] in the
source, implements the SAT standard, i.e. supports SATA devices,
and "just works".  As I mentioned, it is being used by product
vendors who build on top of the aic94xx chip and as far as I know,
by at least one distro, for stability reasons.

Depending on which version of the driver you use, you should
forward questions to the appropriate party maintaining it.

> Thank you for any help!  btw this is the first time i ever wrote a 
> maintainer for help... my pride is definitely hurting right now...

No worries, you just didn't know.

Best wishes,
    Luben


> 
> Best wishes,
> John Scarpa
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

