From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: atomic_kmap for PIO (was Re: Fw: Kernel panic with dc395x in
 2.6.12.2)
Date: Mon, 8 Aug 2005 01:31:15 +0200 (CEST)
Message-ID: <Pine.LNX.4.60.0508080112330.29811@poirot.grange>
References: <20050709175725.75f291bf.rdunlap@xenotime.net>
 <20050721235348.05eace11.rdunlap@xenotime.net> <20050722135055.6cb4597d.rdunlap@xenotime.net>
 <42E17451.6090706@drzeus.cx> <20050722153651.28d5db51.rdunlap@xenotime.net>
 <42E17772.3020903@drzeus.cx> <20050723100945.7d43d063.rdunlap@xenotime.net>
 <42E2933C.4050808@drzeus.cx> <20050723152714.4212ba52.rdunlap@xenotime.net>
 <42E2ECF1.8070501@drzeus.cx> <20050723184014.49629f9e.rdunlap@xenotime.net>
 <42E39462.3040007@drzeus.cx> <20050724100153.3e891484.rdunlap@xenotime.net>
 <42E565FE.4070708@drzeus.cx> <20050725203133.3cfa650d.rdunlap@xenotime.net>
 <42E6A5C3.6070501@drzeus.cx> <20050726202058.133382c1.rdunlap@xenotime.net>
 <42E964CC.5060600@drzeus.cx> <20050728201339.216ab3b8.rdunlap@xenotime.net>
 <42F37893.30006@drzeus.cx> <Pine.LNX.4.60.0508070003520.10832@poirot.grange>
 <42F5FCBF.7080902@drzeus.cx> <Pine.LNX.4.60.0508072
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imap.gmx.net ([213.165.64.20]:64932 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S1753108AbVHGXcC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Aug 2005 19:32:02 -0400
In-Reply-To: <42F68C6A.1070603@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Pierre Ossman <drzeus-list@drzeus.cx>, "Randy.Dunlap" <rdunlap@xenotime.net>, oliver@neukum.name, linux-scsi@vger.kernel.org, Jens Axboe <axboe@suse.de>, James Bottomley <James.Bottomley@SteelEye.com>, Jamie Lenehan <lenehan@twibble.org>

On Sun, 7 Aug 2005, Mike Christie wrote:

> Guennadi Liakhovetski wrote:
> > Now, it would be best, I think, if somebody could review the patches to 
> > dc395x and tmscsim. In case the 2 functions are correct, they could be 
> > included in a central file (scsi_lib?) for all drivers, needing PIO (I 
> 
> would it be possible to modify the scatterwalk code so we can share
> something with other subsystems?

Do you have something specific in mind or you just mean drivers, that I 
mentioned: IDE and libata? If the latter - don't know. I seem to remember 
as somebody described their requirements in the April discussion, they 
seemed different enough to me. I am pretty sure IDE was mentioned as also 
doing PIO sometimes, not even sure if libata really was also discussed. If 
you mean something specific, like iscsi, - what exactly?

Thanks
Guennadi
---
Guennadi Liakhovetski
