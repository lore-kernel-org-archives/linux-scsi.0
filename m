From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] use mod_timer in scsi_add_timer
Date: Sun, 31 Aug 2003 14:24:28 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1062336267.31351.50.camel@dhcp23.swansea.linux.org.uk>
References: <20030831112830.GA19502@lst.de>
	 <1062334317.31351.30.camel@dhcp23.swansea.linux.org.uk>
	 <20030831125356.GA20378@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pc1-cwma1-5-cust4.swan.cable.ntl.com ([80.5.120.4]:48057 "EHLO
	dhcp23.swansea.linux.org.uk") by vger.kernel.org with ESMTP
	id S261911AbTHaNZS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 31 Aug 2003 09:25:18 -0400
In-Reply-To: <20030831125356.GA20378@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org

On Sul, 2003-08-31 at 13:53, Christoph Hellwig wrote:
> > And your change is racy too. You might now call the timer function with
> > the data from the old timeout and the function of the new...
> 
> The data always is scmd.

So why are you setting that field ?

Even if it is true now its an invitation to a very hard to track down
and horrible bug.


