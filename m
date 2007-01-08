From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: PROBLEM: LSIFC909 mpt card fails to recognize devices
Date: Mon, 8 Jan 2007 09:21:58 -0700
Message-ID: <664A4EBB07F29743873A87CF62C26D704E8F0C@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1161341AbXAHQXr@vger.kernel.org>
Content-class: urn:content-classes:message
Sender: linux-kernel-owner@vger.kernel.org
To: Justin Rosander <myrddinemrys@neo.rr.com>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sunday, January 07, 2007 11:07 AM, Justin Rosander wrote:
> Hi Eric,
> I tried recompiling the kernel per your instructions, but I got a
> failure here:
>           CC [M]  drivers/message/fusion/mptbase.o
>         drivers/message/fusion/mptbase.c: In function 'mpt_resume':
>         drivers/message/fusion/mptbase.c:1526: warning: 
> ignoring return value of 'pci_enable_device', declared with 
> attribute warn_unused_result
>           CC [M]  drivers/message/fusion/mptscsih.o
>         drivers/message/fusion/mptscsih.c: In function 
> 'mptscsih_initTarget':
>         drivers/message/fusion/mptscsih.c:2691: error: 'lun' 
> undeclared (first use in this function)
>         drivers/message/fusion/mptscsih.c:2691: error: (Each 
> undeclared identifier is reported only once
>         drivers/message/fusion/mptscsih.c:2691: error: for 
> each function it appears in.)
>         make[4]: *** [drivers/message/fusion/mptscsih.o] Error 1
>         make[3]: *** [drivers/message/fusion] Error 2
>         make[2]: *** [drivers/message] Error 2
>         make[1]: *** [drivers] Error 2
> 
> Did I do something wrong?
> Regards,
> Justin
> 

All you need to do is change lun to sdev->lun.

I fix'ed that compile error in a patch I posted last week on the lsml:

http://marc.theaimsgroup.com/?l=linux-scsi&m=116796872432421&w=2

Can you try again?

Eric Moore
