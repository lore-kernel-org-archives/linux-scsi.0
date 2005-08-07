From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: atomic_kmap for PIO (was Re: Fw: Kernel panic with dc395x in
 2.6.12.2)
Date: Sun, 07 Aug 2005 17:34:18 -0500
Message-ID: <42F68C6A.1070603@cs.wisc.edu>
References: <20050709175725.75f291bf.rdunlap@xenotime.net> <Pine.LNX.4.60.0507132312050.8774@poirot.grange> <42E03506.7030707@drzeus.cx> <20050721235348.05eace11.rdunlap@xenotime.net> <20050722135055.6cb4597d.rdunlap@xenotime.net> <42E17451.6090706@drzeus.cx> <20050722153651.28d5db51.rdunlap@xenotime.net> <42E17772.3020903@drzeus.cx> <20050723100945.7d43d063.rdunlap@xenotime.net> <42E2933C.4050808@drzeus.cx> <20050723152714.4212ba52.rdunlap@xenotime.net> <42E2ECF1.8070501@drzeus.cx> <20050723184014.49629f9e.rdunlap@xenotime.net> <42E39462.3040007@drzeus.cx> <20050724100153.3e891484.rdunlap@xenotime.net> <42E565FE.4070708@drzeus.cx> <20050725203133.3cfa650d.rdunlap@xenotime.net> <42E6A5C3.6070501@drzeus.cx> <20050726202058.133382c1.rdunlap@xenotime.net> <42E964CC.5060600@drzeus.cx> <20050728201339.216ab3b8.rdunlap@xenotime.net> <42F37893.30006@drzeus.cx> <Pine.LNX.4.60.0508070003520.10832
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:17804 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1753069AbVHGWeq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Aug 2005 18:34:46 -0400
In-Reply-To: <Pine.LNX.4.60.0508072214240.7539@poirot.grange>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Pierre Ossman <drzeus-list@drzeus.cx>, "Randy.Dunlap" <rdunlap@xenotime.net>, oliver@neukum.name, linux-scsi@vger.kernel.org, Jens Axboe <axboe@suse.de>, James Bottomley <James.Bottomley@SteelEye.com>, Jamie Lenehan <lenehan@twibble.org>

Guennadi Liakhovetski wrote:
> Now, it would be best, I think, if somebody could review the patches to 
> dc395x and tmscsim. In case the 2 functions are correct, they could be 
> included in a central file (scsi_lib?) for all drivers, needing PIO (I 

would it be possible to modify the scatterwalk code so we can share
something with other subsystems?
