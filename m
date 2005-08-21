From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] minimal SAS transport class
Date: Sun, 21 Aug 2005 08:41:55 +0200
Message-ID: <1124606515.3209.3.camel@laptopd505.fenrus.org>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7A3A@xbl3.ma.emulex.com>
	 <4304DBA1.4050900@pobox.com> <20050819140631.GB12485@lst.de>
	 <43061C3C.2020303@adaptec.com> <20050819175459.GA16619@lst.de>
	 <43061D57.9060201@adaptec.com> <20050819175929.GA5614@infradead.org>
	 <43061FC9.8060301@adaptec.com> <1124481582.5130.88.camel@mulgrave>
	 <430641CF.3070709@adaptec.com> <20050820091814.GB21698@infradead.org>
	 <430769B9.9080302@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:56216 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1750774AbVHUGmJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 21 Aug 2005 02:42:09 -0400
In-Reply-To: <430769B9.9080302@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, andrew.patterson@hp.com, Eric.Moore@lsil.com, ltuikov@yahoo.com, James.Smart@Emulex.Com, Jeff Garzik <jgarzik@pobox.com>, James Bottomley <jejb@steeleye.com>, Christoph Hellwig <hch@infradead.org>


> 
> > that even if my minimal code goes in now there's absolutely no reason
> > we can't replace it completely later on.  See the evolution of the FC
> > transport class.
> 
> Who makes all those decisions?
> 
> More generally, why is SCSI Core not being managed by
> Documentation/ManagingStyle?
> 
> Is it because there's so much vendor interest here?

well Christophs code is the only one out there. So why shouldn't his be
merged? If better code comes along later it's easy to replace (or
extend)... what is the problem here??


