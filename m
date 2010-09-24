From: Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [PATCH] block: set the bounce_pfn to the actual DMA limit rather
  than to max memory
Date: Fri, 24 Sep 2010 15:58:00 +0200
Message-ID: <4C9CAE68.4060706@fusionio.com>
References: <c9516154fabc03112353.1285107750@malahal>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:59344 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932187Ab0IXN62 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Sep 2010 09:58:28 -0400
In-Reply-To: <c9516154fabc03112353.1285107750@malahal>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Malahal Naineni <malahal@us.ibm.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 2010-09-22 00:22, Malahal Naineni wrote:
> The bounce_pfn of the request queue in 64 bit systems is set to the
> current max_low_pfn. Adding more memory later makes this incorrect.

Clearly correct.

> Memory allocated beyond this boot time max_low_pfn appear to require
> bounce buffers (bounce buffers are actually not allocated but used in
> calculating segments that may result in "over max segments limit"
> errors).

But I can't quite convince myself that the change is fully correct. You
don't really explain in your own words what the patch does, just what it
fixes.


-- 
Jens Axboe

