From: Chase Venters <chase.venters@clientec.com>
Subject: Re: Help: strange messages from kernel on IA64 platform
Date: Tue, 16 May 2006 16:00:14 -0500 (CDT)
Message-ID: <Pine.LNX.4.64.0605161558200.32181@turbotaz.ourhouse>
References: <890BF3111FB9484E9526987D912B261901BD84@NAMAIL3.ad.lsil.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay03.pair.com ([209.68.5.17]:54028 "HELO relay03.pair.com")
	by vger.kernel.org with SMTP id S1750817AbWEPVAP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 May 2006 17:00:15 -0400
In-Reply-To: <890BF3111FB9484E9526987D912B261901BD84@NAMAIL3.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Ju, Seokmann" <Seokmann.Ju@lsil.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

On Tue, 16 May 2006, Ju, Seokmann wrote:

> Hi,
>
> During communication in between application and megaraid driver via
> IOCTL, the system displays messages which are not easy to track down.
> Following is one of the messages and same messages with different values
> are poping up regularly.
> ---
> Kernel unaligned access to 0xe00000007f3d80dc ip=0xa0000002000373b1
> ---
>
> I understand the kernel is complaining about the address which is not
> aligned and, found the message is coming from function
> 'ia64_handle_unaligned()' in the arch/ia64/kernel/unaligned.c.
> But, I couldn't find who is calling this function and further details of
> reasons.
>
> Where should I start to figure out it?

It's a trap, which means the CPU is effectively calling that function. My 
best suggestion is to figure out what data is at 0xe00000007f3d80dc and 
what instructions are at 0xa0000002000373b1.

> Thank you,
>
> Seokmann

Thanks,
Chase
