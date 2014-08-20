From: Kashyap Desai <kashyap.desai@avagotech.com>
Subject: RE: [PATCH] scsi.mq:Added enable_cmd_list flags in hostt to reduce
 lock contention
Date: Wed, 20 Aug 2014 18:08:37 +0530
Message-ID: <7932bf422121b7f7d23545abdc0065c8@mail.gmail.com>
References: <201408191819.s7JIIx12019025@palmhbs0.lsi.com> <53F47CF8.3080708@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og128.obsmtp.com ([64.18.2.121]:35477 "EHLO
	exprod7og128.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753383AbaHTMim (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Aug 2014 08:38:42 -0400
Received: by mail-lb0-f170.google.com with SMTP id l4so6828089lbv.29
        for <linux-scsi@vger.kernel.org>; Wed, 20 Aug 2014 05:38:39 -0700 (PDT)
In-Reply-To: <53F47CF8.3080708@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org
Cc: aacraid@adaptec.com, Elliott@hp.com, jbottomley@parallels.com, hch@infradead.org

> -----Original Message-----
> From: Bart Van Assche [mailto:bvanassche@acm.org]
> Sent: Wednesday, August 20, 2014 4:18 PM
> To: Kashyap.Desai@avagotech.com; linux-scsi@vger.kernel.org
> Cc: aacraid@adaptec.com; Elliott@hp.com; jbottomley@parallels.com;
> hch@infradead.org
> Subject: Re: [PATCH] scsi.mq:Added enable_cmd_list flags in hostt to
> reduce
> lock contention
>
> On 08/19/14 20:17, Kashyap.Desai@avagotech.com wrote:
> > +	if (shost->hostt->enable_cmd_list) {
>
> This code is in the hot path which means that caching "enable_cmd_list"
> in struct Scsi_Host (as is done for many other SCSI host parameters)
> probably
> will (slightly) improve performance further. Otherwise this patch looks
> fine to
> me.
I will send updated patch which will cache host template field
"enable_cmd_list" for faster access in Scsi Host.

` Kashyap
>
> Bart.
