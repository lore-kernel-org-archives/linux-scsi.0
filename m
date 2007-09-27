From: Jeff Garzik <jeff@garzik.org>
Subject: Re: generating a Linux WWN?
Date: Thu, 27 Sep 2007 19:40:43 -0400
Message-ID: <46FC3F7B.7010401@garzik.org>
References: <46FB8024.8040807@garzik.org> <46FBB86B.8000206@emulex.com> <CE7B1A4EF22E704CBFFD9A35BA5C822252505C@ausx3mpc110.aus.amer.dell.com> <20070927144649.GV3899@parisc-linux.org> <46FBC723.2070607@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:59757 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751584AbXI0Xkv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Sep 2007 19:40:51 -0400
In-Reply-To: <46FBC723.2070607@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Reed <mdr@sgi.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Patrick_Boyd@Dell.com, James.Smart@Emulex.Com, linux-scsi@vger.kernel.org

Michael Reed wrote:
> Record the WWN of your SAS / FC port so that if/when it goes missing you
> can put it back?  Have spares on site?

Linux:  not just for million dollar data centers any more :)

(sorry, couldn't resist :))

More seriously, SAS will be making an increasing appearance on commodity 
hardware, through the new SAS/SATA chips that are just starting to make 
their appearance (like the chips I'm working on).  And Marvell and 
Broadcom are big guys.  Just wait until the tiny Taiwanese shops start 
cranking out SAS/SATA chips.

With that, you'll get all the joys of low-cost volume production, and 
the user field foibles that come with it.

	Jeff


