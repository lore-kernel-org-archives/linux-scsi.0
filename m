From: Matthew Jacob <mjacob@feral.com>
Subject: Re: ANNOUNCE: saftemon - SCSI Enclosure monitor for linux
Date: Wed, 17 Apr 2002 21:26:40 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.BSF.4.21.0204172122300.80194-100000@beppo>
References: <3CBE1D51.9050300@metaparadigm.com>
Reply-To: mjacob@feral.com
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from beppo.feral.com (168-103-220-153.mtugw1.snva.qwest.net [168.103.220.153])
	by zeus.kernel.org (8.11.6/8.11.6) with ESMTP id g3I4fQd09244
	for <linux-scsi@vger.kernel.org>; Wed, 17 Apr 2002 21:41:42 -0700
In-Reply-To: <3CBE1D51.9050300@metaparadigm.com>
List-Id: linux-scsi@vger.kernel.org
To: Michael Clark <michael@metaparadigm.com>
Cc: Matt_Domsch@Dell.com, linux-scsi@vger.kernel.org


No- SAF-TE was what an *early* version of SES looked like. Then it went it's
own way. Currently there is a bunch of SAF-TE chips out there (e.g. GEM-I and
GEM-II), but the spec is no longer owned by anyone and www.safte.org
disappeared over two years ago, so the ability to even find the spec is
limited to finding those who had downloaded both the .doc and the addendum.

Somebody out there correct me if I'm wrong.

At any rate, you *can* emulate SAF-TE within SES. In fact, it's better to
create an SES driver and then map SAF-TE into it (which is what I did for
Solaris && *BSD). There are a couple of global status items that don't map
easily- and the one wierd thing is to map the overtemp bits (all 17 of them)  
into SES temperature elements. Plus the conversion of SAF-TE temp ranges for
SAF-TE temp elements into SES temperature elements (different ranges). What a
PITA.

-matt


On Thu, 18 Apr 2002, Michael Clark wrote:

> I seem to remember reading somewhere that SAF-TE is component of SES,
> enough so for me to put it in the readme, but I can't back it up as I've 
> never
> had it run on a device that says it is SES capable.
> 
> I'd like to know too so I can correct the readme if need be.
> 
> cheers,
> ~mc
> 
> Matt_Domsch@Dell.com wrote:
> 
> >>will it also drive SES?
> >>
> >
> >Some Dell SCSI backplanes are SES capable, I believe that some aren't.  I'm
> >not sure off-hand of the matrix which is which.  Once we get some time to
> >investigate further I'll report back our findings.
> >
> >Thanks,
> >Matt
> >
> >--
> >Matt Domsch
> >Sr. Software Engineer
> >Dell Linux Solutions www.dell.com/linux
> >Linux on Dell mailing lists @ http://lists.us.dell.com
> >#1 US Linux Server provider for 2001!
> >
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

