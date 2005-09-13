From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: atomic_kmap for PIO (was Re: Fw: Kernel panic with dc395x in
	2.6.12.2)
Date: Mon, 12 Sep 2005 22:09:01 -0500
Message-ID: <1126580941.4825.8.camel@mulgrave>
References: <20050709175725.75f291bf.rdunlap@xenotime.net>
	 <42E03506.7030707@drzeus.cx> <20050721235348.05eace11.rdunlap@xenotime.net>
	 <20050722135055.6cb4597d.rdunlap@xenotime.net> <42E17451.6090706@drzeus.cx>
	 <20050722153651.28d5db51.rdunlap@xenotime.net> <42E17772.3020903@drzeus.cx>
	 <20050723100945.7d43d063.rdunlap@xenotime.net> <42E2933C.4050808@drzeus.cx>
	 <20050723152714.4212ba52.rdunlap@xenotime.net> <42E2ECF1.8070501@drzeus.cx>
	 <20050723184014.49629f9e.rdunlap@xenotime.net> <42E39462.3040007@drzeus.cx>
	 <20050724100153.3e891484.rdunlap@xenotime.net> <42E565FE.4070708@drzeus.cx>
	 <20050725203133.3cfa650d.rdunlap@xenotime.net> <42E6A5C3.6070501@drzeus.cx>
	 <20050726202058.133382c1.rdunlap@xenotime.net> <42E964CC.5060600@drzeus.cx>
	 <20050728201339.216ab3b8.rdunlap@xenotime.net> <42F37893.30006@drzeus.cx>
	 <Pine.LNX.4.60.0508070003520.10832@poirot.grange>
	 <42F5FCBF
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:61388 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932335AbVIMDJG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Sep 2005 23:09:06 -0400
In-Reply-To: <Pine.LNX.4.60.0509052241020.11890@poirot.grange>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 2005-09-05 at 23:50 +0200, Guennadi Liakhovetski wrote:
> I've been buggering the list with this ridiculous problem for quite some 
> time now:-) I understand, it is too risky to apply an untested patch to 
> mainline, but could we either
> 
> 1) get it into -mm
> 
> or
> 
> 2) try to find some beta-testers by applying something like the below:

OK, why don't we do this.  I'll put it into scsi-misc-2.6; that will
queue it for 2.6.14 and also put it in -mm.  It will probably be a month
at least before scsi-misc-2.6 goes into 2.6.14, so you have until that
time to find problems in it and back it out ...

James


