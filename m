From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH] Fix a bdi reregistration race, v3
Date: Wed, 15 Jun 2016 12:49:41 +0200
Message-ID: <11c6333c-dda5-17ee-35cd-f108871cddd7@sandisk.com>
References: <56F9A22F.7020002@sandisk.com> <572BA5EF.6000702@sandisk.com>
 <572BAFB0.2020305@stratus.com> <57309597.1040903@stratus.com>
 <949afe8e-99cf-b46f-1191-45132c835423@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0084.outbound.protection.outlook.com ([207.46.100.84]:9165
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751778AbcFOKty (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Jun 2016 06:49:54 -0400
In-Reply-To: <949afe8e-99cf-b46f-1191-45132c835423@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Lawrence <joe.lawrence@stratus.com>, James Bottomley <james.bottomley@hansenpartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 06/04/2016 01:25 AM, Bart Van Assche wrote:
> Earlier today I discovered a subtle bug in v3 of this patch. It would
> be appreciated if you could give v4 a try. The only substantial
> difference between v3 and v4 is that a "if (dev->class != &sdev_class)"
> test has been added.

(again replying to my own e-mail)

Sorry but even v4 was not perfect. Will post v5 later today.

Bart.
