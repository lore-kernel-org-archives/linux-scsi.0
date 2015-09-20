From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH] scsi: Fix a bdi reregistration race
Date: Sun, 20 Sep 2015 12:57:56 +0300
Message-ID: <55FE8324.9000604@dev.mellanox.co.il>
References: <55FCAB0E.3020707@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:38468 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754414AbbITJ5h (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 20 Sep 2015 05:57:37 -0400
Received: by wiclk2 with SMTP id lk2so76911502wic.1
        for <linux-scsi@vger.kernel.org>; Sun, 20 Sep 2015 02:57:36 -0700 (PDT)
In-Reply-To: <55FCAB0E.3020707@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: James Bottomley <jbottomley@odin.com>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 9/19/2015 3:23 AM, Bart Van Assche wrote:
> Unregister and reregister BDI devices in the proper order. This patch
> avoids that the following kernel warning can get triggered:

Hi Bart,

Can you share the scenario that reproduced this? I think I might
have seen this before.

Thanks,
Sagi.
