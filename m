From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: aacraid driver incomplete regarding info + logging
Date: Fri, 13 Oct 2006 09:05:51 -0400
Message-ID: <547AF3BD0F3F0B4CBDC379BAC7E4189F02D81A23@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([216.52.22.36]:13224 "EHLO
	mail-gw3.adaptec.com") by vger.kernel.org with ESMTP
	id S1751038AbWJMNFx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Oct 2006 09:05:53 -0400
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Metathronius Galabant <m.galabant@googlemail.com>
Cc: linux-scsi@vger.kernel.org

The GPL application aeventd is 50K of text, hardly a handful when locked
in core, occupying space in multiples on a driver update disk or on
initrd image. Imagine the space taken if we had been granted approval to
put the full fledged event monitor and r/o portion of array management
into core!? We had customers & OEMs that demanded for the application
instead of in-core, so can not please everyone, can not manage all
levels of rationality. The bonus is that it adds internationalization
and because it is an application, can be optional, can be modified
without system risks and can be swapped.

Why is it so critical that this occupy kernel memory for you (besides
the marketing perception)? You are free to integrate aeventd into the
driver; anyone can submit a patch. I do not mean that as a threat, Linux
can evolve. However, I urge you to read all the accounts surrounding
attempts to add CSMI to several of the drivers, an attempt at standards
based target and array interrogation and management hooks (Note: the
Adaptec version of the aacraid driver still has this integrated despite
disapproval on the list, we still have some bruises ;-/ ).

Sincerely -- Mark Salyzyn

> -----Original Message-----
> From: Metathronius Galabant [mailto:m.galabant@googlemail.com] 
> Sent: Friday, October 13, 2006 5:42 AM
> To: Salyzyn, Mark
> Cc: linux-scsi@vger.kernel.org
> Subject: Re: aacraid driver incomplete regarding info + logging
> 
> 
> > There is not enough space to waste in the kernel to add 
> such features,
> > and there is a dynamic and complicated relationship between the full
> > fledged native and proprietary management applications shipped by
> 
> Are about maybe a handful of informational printk()s really too much?
> I'm used to this behaviour from all my machines (gdth, lsi, cciss).
> The thing is - because of the driver I had to exchange the adaptec
> raid card for something else.
> 
> Cheers,
> M
> 
