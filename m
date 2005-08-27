From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: regression w/ qla2300 - oopses..
Date: Fri, 26 Aug 2005 18:17:46 -0700
Message-ID: <20050827011746.GT22320@plap.qlogic.org>
References: <20050826212934.GO22165@mea-ext.zmailer.org> <1125092648.5079.110.camel@mulgrave> <20050826145239.6032a509.akpm@osdl.org> <1125094436.5079.122.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:51259 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S965189AbVH0BRv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Aug 2005 21:17:51 -0400
Content-Disposition: inline
In-Reply-To: <1125094436.5079.122.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andrew Morton <akpm@osdl.org>, matti.aarnio@zmailer.org, SCSI Mailing List <linux-scsi@vger.kernel.org>, Greg KH <greg@kroah.com>

On Fri, 26 Aug 2005, James Bottomley wrote:

> On Fri, 2005-08-26 at 14:52 -0700, Andrew Morton wrote:
> > Is there not some nasty little hack we can do to make the crash go away in
> > the interim?
> 
> Well, it's nasty.  The problem is that klist_next() refers to the
> previous element to get the next one.  However, this previous element
> has just been removed and freed.  We could try to open code the
> necessary gets and puts in next_device().
> 
> Could someone check the attached, I think it's the correct open coding?

Hmm, basic loading and unloading tests appear to be fine with the
patch.  I'll try to allocate some additional boxes for weekend runs.

Seems minimal, hopefully it will make it into 2.6.13.

--
av
