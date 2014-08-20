From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] scsi.mq:Added enable_cmd_list flags in hostt to reduce
 lock contention
Date: Wed, 20 Aug 2014 12:48:24 +0200
Message-ID: <53F47CF8.3080708@acm.org>
References: <201408191819.s7JIIx12019025@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sf2.bxl.stone.is ([5.134.1.239]:60608 "EHLO sf2.bxl.stone.is"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750985AbaHTKt3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Aug 2014 06:49:29 -0400
In-Reply-To: <201408191819.s7JIIx12019025@palmhbs0.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kashyap.Desai@avagotech.com, linux-scsi@vger.kernel.org
Cc: aacraid@adaptec.com, Elliott@hp.com, jbottomley@parallels.com, hch@infradead.org

On 08/19/14 20:17, Kashyap.Desai@avagotech.com wrote:
> +	if (shost->hostt->enable_cmd_list) {

This code is in the hot path which means that caching "enable_cmd_list"
in struct Scsi_Host (as is done for many other SCSI host parameters)
probably will (slightly) improve performance further. Otherwise this
patch looks fine to me.

Bart.

