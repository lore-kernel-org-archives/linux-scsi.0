From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 1/6] scsi: Add 'access_state' and 'preferred_path'
 attribute
Date: Tue, 1 Mar 2016 12:54:28 -0800
Message-ID: <56D60184.80201@sandisk.com>
References: <1456808143-88932-1-git-send-email-hare@suse.de>
 <1456808143-88932-2-git-send-email-hare@suse.de>
 <20160301130604.GC7616@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1bon0069.outbound.protection.outlook.com ([157.56.111.69]:33455
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750936AbcCAUyd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Mar 2016 15:54:33 -0500
In-Reply-To: <20160301130604.GC7616@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Ewan Milne <emilne@redhat.com>, James Bottomley <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 03/01/2016 05:06 AM, Christoph Hellwig wrote:
> (I don't care about the *printf holy war for constant strings.  In all
>   truth sysfs should switch to the seq_file API ASAP and end that misery..)

Agreed that it's not that important whether snprintf() or sprintf() is 
used. But sprintf() has an advantage, namely that it's not needed to 
specify the output buffer size. Which means fewer magic constants and 
hence easier to read code ...

Bart.
