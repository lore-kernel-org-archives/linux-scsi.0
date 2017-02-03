From: Johannes Thumshirn <jth@kernel.org>
Subject: Re: [PATCHv2 3/6] sg: protect accesses to 'reserved' page array
Date: Fri, 3 Feb 2017 13:23:25 +0100
Message-ID: <36626238-99a5-be1c-3e40-a48d4df861e0@kernel.org>
References: <1486124305-104141-1-git-send-email-hare@suse.de>
 <1486124305-104141-4-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wj0-f196.google.com ([209.85.210.196]:34939 "EHLO
        mail-wj0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751878AbdBCMX3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Feb 2017 07:23:29 -0500
Received: by mail-wj0-f196.google.com with SMTP id i7so711684wjf.2
        for <linux-scsi@vger.kernel.org>; Fri, 03 Feb 2017 04:23:28 -0800 (PST)
In-Reply-To: <1486124305-104141-4-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Doug Gilberg <dgilbert@interlog.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>


On 02/03/2017 01:18 PM, Hannes Reinecke wrote:
> The 'reserved' page array is used as a short-cut for mapping
> data, saving us to allocate pages per request.
> However, the 'reserved' array is only capable of holding one
> request, so this patch introduces a mutex for protect
> 'sg_fd' against concurrent accesses.
>
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>
Tested-by: Johannes Thumshirn <jthumshirn@suse.de>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
