From: Mark Lobo <ntdeveloper2002@yahoo.com>
Subject: Re: AIO for SG
Date: Wed, 12 Nov 2003 18:58:25 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031113025825.83532.qmail@web9507.mail.yahoo.com>
References: <3FADF9BA.3050802@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web9507.mail.yahoo.com ([216.136.129.21]:35685 "HELO
	web9507.mail.yahoo.com") by vger.kernel.org with SMTP
	id S262108AbTKMC6Z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Nov 2003 21:58:25 -0500
In-Reply-To: <3FADF9BA.3050802@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org

Douglas,
Thanks, I will definitely try it out.

I had one question about the aio calls though. I was
looking through the kernel sources after applying the
patch, and then looked at the examples you have
provided. How does the io_setcallback work? The kiocb
and the aiocb structure had no way to specify a
callback function in the kernel/usermode. What exactly
does aio_complete do and how is the callback done?
Atleast until SG, there was no way of calling back,
didnt look anywhere else.How does it work from the
kernel?

TIA
Mark

--- Douglas Gilbert <dougg@torque.net> wrote:
> Mark Lobo wrote:
> > Guys,
> > Is there a patch available which adds the aio
> > interface to SG? (aio_read, aio_complete etc) 
> 
> Mark,
> I have ported the aio support from lk 2.5.69 to my
> latest
> version of sg which I sent to this list a few days
> ago.
> 
> The 2 attachments:
>    1) incremental against my patch a few days ago.
> This makes
>       it simpler to see the changes associated with
> aio
>    2) against the version of sg found in lk
> 2.6.0-test9 (so
>       it includes my cdev and seqfile patches)
> 
> The sg3_utils-1.05 package found at
> http://www.torque.net/sg
> has a file called sg_simple_aio.c ** in its
> "examples" directory.
> You need libaio to link it. Links ok with
> libaio-0.3.92 but
> libaio-0.3.93 gives undefines (seems to be related
> to i64, ppc
> etc support added in 0.3.93, strange).
> 
> ** beware of the "sleep(3)" before read() [best
> remove it].
> 
> Doug Gibert
> 
> 

> ATTACHMENT part 2 application/x-gzip
name=sg_aio_260t9dpg.diff.gz


> ATTACHMENT part 3 application/x-gzip
name=sg_aio_260t9.diff.gz



__________________________________
Do you Yahoo!?
Protect your identity with Yahoo! Mail AddressGuard
http://antispam.yahoo.com/whatsnewfree
