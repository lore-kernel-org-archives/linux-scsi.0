From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [RFC] libata new EH document
Date: Fri, 02 Sep 2005 09:09:39 +0200
Message-ID: <4317FAB3.7050304@s5r6.in-berlin.de>
References: <20050901043850.15186.qmail@web51611.mail.yahoo.com>	 <43169520.6040008@gmail.com>  <20050901055421.GA23496@havoc.gtf.org> <1125581097.4834.5.camel@mulgrave> <4317755C.5080700@adaptec.com> <431776A0.2030107@pobox.com> <43177C0B.9040500@adaptec.com> <43178060.9030601@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:41917 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S1030521AbVIBHLK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 2 Sep 2005 03:11:10 -0400
In-Reply-To: <43178060.9030601@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Luben Tuikov <luben_tuikov@adaptec.com>, James Bottomley <James.Bottomley@SteelEye.com>, Tejun Heo <htejun@gmail.com>, ltuikov@yahoo.com, Albert Lee <albertcc@tw.ibm.com>, linux-ide@vger.kernel.org, SCSI Mailing List <linux-scsi@vger.kernel.org>, Doug Maxey <dwm@maxeymade.com>

Jeff Garzik wrote:
> Linux is NOT about big designs.  Linus says "do what you must, and no 
> more."

The scsi subsystem is used in so many divergent areas, its set of 
requirements is "big". Therefore its design has to be "big".

> The future will bring other "baby steps" that evolve us towards a more 
> modular design where each LLD may register themselves with a storage 
> system, associate themselves with
[...]

...and hopefully a future where a LLD can be written and maintained 
without profound knowledge of many implementation details of scsi mid- 
and high-level.

(Sorry for digressing further from the thread's subject, although it 
still seems related.)
-- 
Stefan Richter
-=====-=-=-= =--= ---=-
http://arcgraph.de/sr/
