From: David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] qla1280: use request_firmware
Date: Mon, 14 Jul 2008 06:59:03 -0700
Message-ID: <1216043943.27455.14.camel@shinybook.infradead.org>
References: <1215770284.2733.10.camel@jaswinder.satnam>
	 <487B1C73.5000202@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:45405 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753664AbYGNN7L (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Jul 2008 09:59:11 -0400
In-Reply-To: <487B1C73.5000202@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jes Sorensen <jes@sgi.com>
Cc: Jaswinder Singh <jaswinder@infradead.org>, LKML <linux-kernel@vger.kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>, kernel-janitors <kernel-janitors@vger.kernel.org>, kernelnewbies <kernelnewbies@nl.linux.org>, linux-scsi@vger.kernel.org, hch@infradead.org

On Mon, 2008-07-14 at 11:29 +0200, Jes Sorensen wrote:
> However for my boot device, this is going to be a royal pain in the
> butt for developers who wish to boot test kernels with a / sitting on
> a 1280.

Not so. All they have to do is choose to build the firmware into their
kernel, and it works as it always did.

-- 
dwmw2

