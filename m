From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [Lsf] [LSF/MM TOPIC] block-mq issues with FC
Date: Fri, 8 Apr 2016 11:14:24 -0700
Message-ID: <5707F500.6030206@sandisk.com>
References: <57079616.4000202@suse.de> <20160408174006.GI2781@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0098.outbound.protection.outlook.com ([207.46.100.98]:9440
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750908AbcDHSOd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Apr 2016 14:14:33 -0400
In-Reply-To: <20160408174006.GI2781@linux.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@linux.intel.com>, Hannes Reinecke <hare@suse.de>
Cc: "lsf@lists.linux-foundation.org" <lsf@lists.linux-foundation.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>

On 04/08/2016 10:40 AM, Matthew Wilcox wrote:
>   - Interrupt steering needs to be controlled by block-mq instead of
>     the driver.  It's pointless to have each driver implement its own
>     policies on interrupt steering, irqbalanced remains a source of
>     end-user frustration, and block-mq can change the queue<->cpu mapping
>     without the driver's knowledge.

I'm looking forward to the day that I will be able to drop my script for 
spreading interrupts manually (see also the fifth attachment of 
http://thread.gmane.org/gmane.linux.kernel.device-mapper.devel/21312/focus=98409).

Bart.

