From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH] Fix a memory leak in scsi_host_dev_release()
Date: Tue, 24 Nov 2015 16:50:15 +0200
Message-ID: <56547927.4050307@dev.mellanox.co.il>
References: <564D0224.9040001@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:34452 "EHLO
	mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754496AbbKXOuT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Nov 2015 09:50:19 -0500
Received: by wmvv187 with SMTP id v187so213156587wmv.1
        for <linux-scsi@vger.kernel.org>; Tue, 24 Nov 2015 06:50:18 -0800 (PST)
In-Reply-To: <564D0224.9040001@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>



On 19/11/2015 00:56, Bart Van Assche wrote:
> Avoid that kmemleak reports the following memory leak if a
> SCSI LLD calls scsi_host_alloc() and scsi_host_put() but neither
> scsi_host_add() nor scsi_host_remove(). The following shell
> command triggers that scenario:

Looks good,

Reviewed-by: Sagi Grimberg <sagig@mellanox.com>
