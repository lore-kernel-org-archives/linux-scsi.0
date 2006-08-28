From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] aic94xx: convert to request_firmware interface
Date: Sun, 27 Aug 2006 22:47:23 -0500
Message-ID: <1156736843.3460.31.camel@mulgrave.il.steeleye.com>
References: <1156733286.3460.26.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:1673 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932383AbWH1DrY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 27 Aug 2006 23:47:24 -0400
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id k7S3lN501252
	for <linux-scsi@vger.kernel.org>; Sun, 27 Aug 2006 23:47:23 -0400
In-Reply-To: <1156733286.3460.26.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

On Sun, 2006-08-27 at 21:48 -0500, James Bottomley wrote:
> This patch is too big to inline, so I attached it compressed.
> 
> This, I think, concludes the work necessary to get this thing into
> scsi-misc and begin working on it upstream.

I forgot to say that the firmware file is here:

http://www.kernel.org/pub/linux/kernel/people/jejb/aic94xx-seq.fw

James


