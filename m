From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH] libata: fix probe_ent alloc/free bugs
Date: Sat, 17 Feb 2007 21:27:31 +0300
Message-ID: <45D74913.4040906@ru.mvista.com>
References: <45D710E8.3090104@gmail.com>	 <1171725374.3379.15.camel@mulgrave.il.steeleye.com>	 <45D73A55.90008@gmail.com>  <45D73ED4.80505@ru.mvista.com> <1171736398.3379.22.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from h155.mvista.com ([63.81.120.155]:58309 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750987AbXBQS1l (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 17 Feb 2007 13:27:41 -0500
In-Reply-To: <1171736398.3379.22.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Tejun Heo <htejun@gmail.com>, Jeff Garzik <jeff@garzik.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Hello.

James Bottomley wrote:

>>>+    probe_ent = devm_kzalloc(dev, sizeof(*probe_ent), GFP_KERNEL);
>>>    if (!probe_ent) {
>>>        printk(KERN_ERR DRV_NAME "(%s): out of memory\n",
>>>               kobject_name(&(dev->kobj)));

>>[...]

>>    The patch certainly looks mangled tab-wise. :-)

> It isn't, though, so I think you'll find it's a problem with your mail
> client.

    You're right. :-<
    It seems to "dislike" format=flowed in this message (that's what is 
different from other mails where tabs are shown as is)...

> James

MBR, Sergei
