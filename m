From: Marcelo Tosatti <marcelo.tosatti@cyclades.com>
Subject: Re: [patch] 2.6 -- add IOI Media Bay to SCSI quirk list
Date: Fri, 13 Aug 2004 18:32:41 -0300
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040813213241.GC30627@logos.cnet>
References: <200408122137.i7CLbGU13688@ra.tuxdriver.com> <20040812225118.GA20904@beaverton.ibm.com> <411BF6A5.2030306@tuxdriver.com> <20040813002756.GA21763@beaverton.ibm.com> <411C17B4.7030804@tuxdriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:14307 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S267656AbUHMW5A
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Aug 2004 18:57:00 -0400
Content-Disposition: inline
In-Reply-To: <411C17B4.7030804@tuxdriver.com>
List-Id: linux-scsi@vger.kernel.org
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Patrick Mansfield <patmans@us.ibm.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

On Thu, Aug 12, 2004 at 09:21:56PM -0400, John W. Linville wrote:
> Patrick Mansfield wrote:
> 
> >Only add borken devices to the list, so it is a list of bad devices rather
> >than a list of good ones.
> > 
> >
> 
> I now see the comments about the list being deprecated.  I withdraw the 
> 2.6 patch.  I still think the 2.4 patch is wortwhile, unless there is an 
> overhaul going-on there as well.

Not on 2.4.x, no. Care to write & test a patch?
