From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] s390 error: implicit declaration of function sg_dma_len
Date: Fri, 25 May 2007 14:05:54 -0700 (PDT)
Message-ID: <20070525.140554.98863560.davem@davemloft.net>
References: <4656A778.2000403@suse.de>
	<20070525.021303.70218696.davem@davemloft.net>
	<1180100858.3717.3.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52173
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1765708AbXEYVFv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 May 2007 17:05:51 -0400
In-Reply-To: <1180100858.3717.3.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: hare@suse.de, olaf@aepfle.de, linux-scsi@vger.kernel.org

From: James Bottomley <James.Bottomley@SteelEye.com>
Date: Fri, 25 May 2007 08:47:38 -0500

> OK, I won't ... but we're growing users of this base driver now, like
> this one:
> 
> http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-misc-2.6.git;a=commit;h=352e921f0dd42f79652cdb50dd91122d068d7209
> 
> Could you share the updates you're planning with linux-scsi, just so we
> don't run into problems?

Only the driver front-end Kconfg's will exist, which will
properly check for things like platform and bus type
dependencies, and the Makefile goes:

obj-$(FOO_ESP)	+= esp_core.o foo_esp.o
