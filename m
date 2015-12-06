From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 73/71] ncr5380: Use runtime register mapping
Date: Sun, 6 Dec 2015 09:42:53 +0100
Message-ID: <CAMuHMdWCvQ6ZQLYzoDZ_eMBA2=dk5aq-0=j-7CL-zqjhwwdOzg@mail.gmail.com>
References: <20151118083455.331768508@telegraphics.com.au>
	<1449262855-4538-1-git-send-email-linux@rainbow-software.org>
	<alpine.LNX.2.00.1512050943400.31458@nippy.intranet>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:34256 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603AbbLFImy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Dec 2015 03:42:54 -0500
In-Reply-To: <alpine.LNX.2.00.1512050943400.31458@nippy.intranet>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: Ondrej Zary <linux@rainbow-software.org>, Michael Schmitz <schmitzmic@gmail.com>, Linux/m68k <linux-m68k@vger.kernel.org>, scsi <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On Sun, Dec 6, 2015 at 4:39 AM, Finn Thain <fthain@telegraphics.com.au> wrote:
>> -             while (NCR5380_read(C400_CONTROL_STATUS_REG) & CSR_HOST_BUF_NOT_RDY);
>> +             while (NCR5380_read(hostdata->c400_ctl_status) & CSR_HOST_BUF_NOT_RDY);
>
> The semicolon should appear on the next line where it is more visible.

And adding a cpu_relax() to the empty loop body is another good visual cue.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
