From: "Yinghai Lu" <yhlu.kernel@gmail.com>
Subject: Re: AIC79XX PCI-X SCSI mystery
Date: Fri, 27 Jul 2007 23:39:50 -0700
Message-ID: <86802c440707272339r1b9f5451wee321b9e3fa70833@mail.gmail.com>
References: <1185523030.7330.24.camel@tycho.astronomy.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.178]:34617 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754383AbXG1Gjv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 28 Jul 2007 02:39:51 -0400
Received: by wa-out-1112.google.com with SMTP id v27so1153496wah
        for <linux-scsi@vger.kernel.org>; Fri, 27 Jul 2007 23:39:50 -0700 (PDT)
In-Reply-To: <1185523030.7330.24.camel@tycho.astronomy.dk>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bjarne Thomsen <bjarne.b.thomsen@gmail.com>, "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On 7/27/07, Bjarne Thomsen <bjarne.b.thomsen@gmail.com> wrote:
> I have a dual Opteron Tyan MB (S2885) with 4 PCI-X slots.
> The 2 first slots can work up to 100 MHz, the last 2 up to 66 MHz.
>
> I have 2 PCI-X Adaptec SCSI controllers: 29160 and 39320A.
> A SCSI disk is connected to port A on the 39320A.
>
> When I mount the 39320A in any of the 4 slots the system hangs
> after a few seconds (with no error messages in syslog) when I
> copy a directory with many files to the SCIS disk.
>
> However, when I mount both controllers in either slots 1 and 2
> or slots 3 and 4 I can copy 25GB of files without any hang-up.
>
> I need some help to figure this out. It is a mystery to me.
>

Could it be FW in 29160 is more new than that in 39320A?
and when two cards installed, only one FW is executed...

YH
