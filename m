From: Jes Sorensen <jes@sgi.com>
Subject: Re: [PATCH] qla1280: use request_firmware
Date: Mon, 14 Jul 2008 11:29:23 +0200
Message-ID: <487B1C73.5000202@sgi.com>
References: <1215770284.2733.10.camel@jaswinder.satnam>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay1.sgi.com ([192.48.171.29]:46508 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754511AbYGNJ32 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Jul 2008 05:29:28 -0400
In-Reply-To: <1215770284.2733.10.camel@jaswinder.satnam>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jaswinder Singh <jaswinder@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, David Woodhouse <dwmw2@infradead.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>, kernel-janitors <kernel-janitors@vger.kernel.org>, kernelnewbies <kernelnewbies@nl.linux.org>, linux-scsi@vger.kernel.org, hch@infradead.org

Jaswinder Singh wrote:
> this is a first draft; please be kind :)
> 
> Firmware blob is little endian looks like this...
> 	unsigned char  Version1
> 	unsigned char  Version2
> 	unsigned char  Version3
> 	unsigned char  Padding
> 	unsigned short start_address
> 	unsigned short data

Hello,

As the maintainer of this driver I am going to say that I think this is
a stupid change. Yes I know that politically there's a move to make
everything use request firmware. However for my boot device, this is
going to be a royal pain in the butt for developers who wish to boot
test kernels with a / sitting on a 1280.

IMHO this patch brings us nothing, but provides a lot of unnecessary
hassle for users.

Nacked-By: Jes Sorensen <jes@sgi.com>

Regards,
Jes
