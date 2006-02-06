From: "Ju, Seokmann" <Seokmann.Ju@lsil.com>
Subject: RE: megaraid SATA-150-4,6 on x86_64
Date: Mon, 6 Feb 2006 06:41:06 -0700
Message-ID: <9738BCBE884FDB42801FAD8A7769C265142050@NAMAIL1.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:3299 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S932098AbWBFNlM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Feb 2006 08:41:12 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Gorazd Golob <gorazd.golob@noviforum.si>, linux-scsi@vger.kernel.org

Hi,

On Friday, February 03, 2006 7:52 PM, Gorazd Golob wrote: 
> I forgot to mention - same problem apear with old 
> "MEGARAID_LEGACY" and
> new one "MEGARAID_NEWGEN" .
How about the performance of those controllers in 2.4 kernel on x86_64 platform? Are they performing well as you expect?
In my opinion, the issue more towards kernel if it happening on certain version of kernel or later. I strongly recommend you to try with latest kernel 2.6.15 that is available on kernel.org or even with the kernel that is available on git.

Thank you,


> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org 
> [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Gorazd Golob
> Sent: Friday, February 03, 2006 7:52 PM
> To: linux-scsi@vger.kernel.org
> Subject: Re: megaraid SATA-150-4,6 on x86_64
> 
> 
> I forgot to mention - same problem apear with old 
> "MEGARAID_LEGACY" and
> new one "MEGARAID_NEWGEN" .
> 
> 
> > I'm looking for an answer or solution regarding lsi's 
> megaraid sata-150
> > working with >=2.6.11 kernel on x86_64. I've tried a few of 
> those cards
> > and have a very good experience with those on Linux kernels 
> from 2.4.x
> > to latests 2.6 on x86 platform. Suddenly I come into 
> trouble on x86_64
> > platform with 2.6 kernels - those cards are working with 
> about 512kbytes
> > per second (write) - which is strange. If I boot 32bit 
> kernel on same
> > hardware the throput is about 50mbytes/s - which is showing  that
> > megaraid driver in >2.6.11 x86_64 kernels is not working 
> properly with
> > megaraid SATA-150 raid cards. Newer megaraids SATA 300-8 are working
> > perfect on x86_64. Does anybody found same problem? 
> > 
> > Thanks, Gorazd 
> > 
> > -
> > To unsubscribe from this list: send the line "unsubscribe 
> linux-scsi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> -
> To unsubscribe from this list: send the line "unsubscribe 
> linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
