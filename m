From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] Ghost devices being reported with AIC7XXX version 6.2.6
Date: Thu, 31 Oct 2002 16:14:47 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200210312114.g9VLElc04538@localhost.localdomain>
References: <mbrown@emc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id NAA25099
	for <linux-scsi@vger.kernel.org>; Thu, 31 Oct 2002 13:14:52 -0800
In-Reply-To: Message from Mike Brown <mbrown@emc.com>
   of "Thu, 31 Oct 2002 16:00:54 EST." <20021031210054.GX574@lapi0061>
List-Id: linux-scsi@vger.kernel.org
To: Mike Brown <mbrown@emc.com>
Cc: Matthew Jacob <mjacob@feral.com>, "Justin T. Gibbs" <gibbs@scsiguy.com>, bferjul@emc.com, jkrasner@emc.com, conway_heather@emc.com, linux-scsi@vger.kernel.org

mbrown@emc.com said:
> I haven't been tracking 2.5, but I knew there were plans to push push
> the scanning code and the blacklist stuff into a userspace scsid.  Did
> this make it? 

That was my plan, but I spent too much time scraping out the innards.  I hope 
to do it for 2.7

James


