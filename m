From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 00/23] ALUA device handler update, part II
Date: Mon, 8 Feb 2016 11:39:51 -0800
Message-ID: <56B8EF07.3020007@sandisk.com>
References: <1454942086-128704-1-git-send-email-hare@suse.de>
 <56B8A819.7040007@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2on0087.outbound.protection.outlook.com ([65.55.169.87]:64229
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751075AbcBHTjz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Feb 2016 14:39:55 -0500
In-Reply-To: <56B8A819.7040007@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>

On 02/08/2016 06:37 AM, Hannes Reinecke wrote:
> And for the impatient I've pushed the entire patchset to my kernel
> repository at kernel.org:
>
> kernel.org/pub/scm/linux/kernel/git/hare/scsi-devel.git alua-2.v5

Hello Hannes,

I will try to free up some time to help with reviewing and testing this 
patch series. But before I can do that the v4.5-rc multipath code needs 
to be stabilized first. See also 
https://www.redhat.com/archives/dm-devel/2016-February/msg00066.html.

Bart.
