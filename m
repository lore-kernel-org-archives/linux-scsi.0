From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] aic7xxx bouncing over 4G
Date: Sat, 28 Dec 2002 09:00:51 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200212281500.gBSF0pc01929@localhost.localdomain>
References: <riel@conectiva.com.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id HAA22755
	for <linux-scsi@vger.kernel.org>; Sat, 28 Dec 2002 07:00:58 -0800
In-Reply-To: Message from Rik van Riel <riel@conectiva.com.br>
   of "Sat, 28 Dec 2002 11:33:02 -0200." <Pine.LNX.4.50L.0212281131580.26879-100000@imladris.surriel.com>
List-Id: linux-scsi@vger.kernel.org
To: Rik van Riel <riel@conectiva.com.br>
Cc: Tomas Szepe <szepe@pinerecords.com>, Marcelo Tosatti <marcelo@conectiva.com.br>, Samuel Flory <sflory@rackable.com>, "Justin T. Gibbs" <gibbs@scsiguy.com>, Janet Morgan <janetmor@us.ibm.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>

riel@conectiva.com.br said:
> If it's the new driver, it's breaking on WAY too many machines and I
> have no idea why it got ever merged... 

It got merged because no-one was testing it when supplied in its current form 
outside the 2.5 tree and because no-one was fixing the older incarnation of 
this driver that was in the tree.  Including it was a caclulated risk 
mitigated significantly because we still have a maintained aic7xxx_old driver.

So far, the only bug report I have is from Andrew Morton proving that it still 
doesn't get it's bounce buffers right.

I assume all your bug reports are on their way to linux-scsi?

James


