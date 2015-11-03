From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v2] string_helpers: fix precision loss for some inputs
Date: Tue, 03 Nov 2015 14:37:35 -0800
Message-ID: <1446590255.6440.48.camel@HansenPartnership.com>
References: <1446582810.6440.36.camel@HansenPartnership.com>
	 <1446585708.6440.47.camel@HansenPartnership.com>
	 <563928FD.8010901@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:45732 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965004AbbKCWhh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Nov 2015 17:37:37 -0500
In-Reply-To: <563928FD.8010901@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: "linux@rasmusvillemoes.dk" <linux@rasmusvillemoes.dk>, linux-scsi <linux-scsi@vger.kernel.org>

On Tue, 2015-11-03 at 13:37 -0800, Bart Van Assche wrote:
> On 11/03/2015 01:21 PM, James Bottomley wrote:
> > +	while (blk_size >= UINT_MAX)
> >   		i++;
> 
> (reduced CC-list)

Let's keep at least the lists in cc.

> Hello James,
> 
> Is the above loop an infinite loop if blk_size >= UINT_MAX ?

Yes, a little too much truncation over the original.  I'll post a v3.

James


