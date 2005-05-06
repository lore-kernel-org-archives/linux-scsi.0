From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Empty partition nodes not created (was device node issues with
	recent mm's and udev)
Date: Fri, 06 May 2005 09:12:47 -0500
Message-ID: <1115388767.4989.2.camel@mulgrave>
References: <d4757e6005050219514ece0c0a@mail.gmail.com>
	 <20050503031421.GA528@kroah.com>
	 <20050502202620.04467bbd.rddunlap@osdl.org>
	 <20050506080056.GD4604@pclin040.win.tue.nl>
	 <20050506081009.GX23013@shell0.pdx.osdl.net>
	 <20050506084259.GB25418@apps.cwi.nl>
	 <20050506020518.0b0afdc3.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:22236 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261203AbVEFON1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 May 2005 10:13:27 -0400
In-Reply-To: <20050506020518.0b0afdc3.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>, dwmw2@infradead.org
Cc: Andries Brouwer <Andries.Brouwer@cwi.nl>, chrisw@osdl.org, aebr@win.tue.nl, "Randy.Dunlap" <rddunlap@osdl.org>, Greg KH <greg@kroah.com>, joecool1029@gmail.com, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>

On Fri, 2005-05-06 at 02:05 -0700, Andrew Morton wrote:
> > Should it be backed out of 2.6.11.8? Possibly - but if it will be
> > part of 2.6.12 or 2.6.13 then I would be inclined to leave it.
> > 
> > Andrew asks whether it should be removed from -mm.
> 
> It was merged into Linus's tree on March 8th (via bk, thank gawd.  How do
> you find out that sort of info using git?  Generating a full log is
> cheating).

Well, moving offtopic, but it is of relevance to people who use git.
The answer is that the information exists (we can use the commit tree to
reconstruct the file data) but that no-one has yet come up with a file
history viewing tool.  I think David Woodhouse is the closest to
producing one of these, David?

James
 

