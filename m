From: Dale Blount <linux-kernel@dale.us>
Subject: Re: [PATCH] scsi disk: report size without overflow
Date: Fri, 21 Oct 2005 17:02:07 -0400
Message-ID: <1129928527.23920.62.camel@dale.velocity.net>
References: <20051020205532.16b65fa7.rdunlap@xenotime.net>
	 <1129915249.3440.42.camel@mulgrave>
	 <Pine.LNX.4.58.0510211345080.32061@shark.he.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.velocity.net ([66.211.211.55]:53388 "EHLO
	mail.velocity.net") by vger.kernel.org with ESMTP id S1751015AbVJUVCI
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Oct 2005 17:02:08 -0400
In-Reply-To: <Pine.LNX.4.58.0510211345080.32061@shark.he.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Randy.Dunlap" <rdunlap@xenotime.net>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, scsi <linux-scsi@vger.kernel.org>, akpm <akpm@osdl.org>

> > I'm really not terribly sympathetic to anyone trying Terrabyte discs on
> > a non-LBD 32 bit kernel.  The potential for overflow (and consequent
> > data loss) is pretty huge.
> 
> Yes, I agree with that.
> 

I'll agree with that as well, but there should be a note left on
CONFIG_LBD's help menu that states 1TB (or whatever the actual limit is)
instead of 2TB then.

Also are there any performance implications for using CONFIG_LBD?

Dale

