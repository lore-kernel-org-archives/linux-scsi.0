From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH v2] scsi: NCR5380: use msecs_to_jiffies for conversions
Date: Sun, 1 Feb 2015 17:23:13 +1100 (AEDT)
Message-ID: <alpine.LNX.2.00.1502011708210.3047@nippy.intranet>
References: <1422692020-6607-1-git-send-email-der.herr@hofr.at> <alpine.LNX.2.00.1502010957150.30584@nippy.intranet> <d0a6819903df0864d2785bc209409cef@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:33294 "EHLO
	kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864AbbBAGXz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 1 Feb 2015 01:23:55 -0500
In-Reply-To: <d0a6819903df0864d2785bc209409cef@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Schmitz <schmitzmic@gmail.com>
Cc: Nicholas Mc Guire <der.herr@hofr.at>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org


On Sun, 1 Feb 2015, Michael Schmitz wrote:

> Finn, Nicholas,
> 
> > On Sat, 31 Jan 2015, Nicholas Mc Guire wrote:
> >
> > > This is only an API consolidation to make things more readable.
> > >
> > > Instances of var * HZ / 1000 are replaced by msecs_to_jiffies(var).
> >
> > ... and some instances of "value" are replaced by 
> > "msecs_to_jiffies(value)" which seems to be completely wrong.
> 
> The values for USLEEP_* are taken to be in units jiffies, according to 
> comments in NCR5380.c. Replacing them by the msecs_to_jiffies conversion 
> is in fact wrong.
> 
> Please drop the changes to g_NCR5380.c for that reason.
> 
> Cheers,
> 
>   Michael
> 

Yes, that's a better way to put it than my regrettably short-tempered 
message.

-- 
