From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCHv8 20/23] scsi: Add 'access_state' attribute
Date: Sat, 20 Feb 2016 07:16:31 -0800
Message-ID: <56C8834F.50304@sandisk.com>
References: <1455869840-122786-1-git-send-email-hare@suse.de>
 <1455869840-122786-21-git-send-email-hare@suse.de>
 <56C7688A.2050608@sandisk.com> <56C81DB5.7070102@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2on0095.outbound.protection.outlook.com ([65.55.169.95]:59008
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751490AbcBTPRx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 20 Feb 2016 10:17:53 -0500
In-Reply-To: <56C81DB5.7070102@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, James Bottomley <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 02/20/16 00:03, Hannes Reinecke wrote:
> Also when using your suggestion the 'access_state' attribute will only
> be created _after_ the 'ADD' uevent, making it impossible to use it from
> udev events.

Can you give an example in which it would be useful to read the ALUA 
state from a udev handler ? I'm not sure such an example exists.

> If you're absolutely against it we can drop the 'access_state' patches
> (ie patch 20-22) and have them folded into a separate patchset.

That sounds like a good idea to me.

Thanks,

Bart.
