From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] libata: fix probe_ent alloc/free bugs
Date: Sat, 17 Feb 2007 12:19:58 -0600
Message-ID: <1171736398.3379.22.camel@mulgrave.il.steeleye.com>
References: <45D710E8.3090104@gmail.com>
	 <1171725374.3379.15.camel@mulgrave.il.steeleye.com>
	 <45D73A55.90008@gmail.com>  <45D73ED4.80505@ru.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:50640 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S2993041AbXBQSUN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 17 Feb 2007 13:20:13 -0500
In-Reply-To: <45D73ED4.80505@ru.mvista.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Tejun Heo <htejun@gmail.com>, Jeff Garzik <jeff@garzik.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sat, 2007-02-17 at 20:43 +0300, Sergei Shtylyov wrote:
> > +    probe_ent = devm_kzalloc(dev, sizeof(*probe_ent), GFP_KERNEL);
> >     if (!probe_ent) {
> >         printk(KERN_ERR DRV_NAME "(%s): out of memory\n",
> >                kobject_name(&(dev->kobj)));
> [...]
> 
>     The patch certainly looks mangled tab-wise. :-)

It isn't, though, so I think you'll find it's a problem with your mail
client.

James


