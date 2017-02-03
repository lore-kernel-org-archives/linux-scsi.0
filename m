From: Johannes Thumshirn <jth@kernel.org>
Subject: Re: [PATCHv2 1/6] sg: disable SET_FORCE_LOW_DMA
Date: Fri, 3 Feb 2017 13:20:26 +0100
Message-ID: <e15a79a5-e4f1-1349-ab28-98869c963f6b@kernel.org>
References: <1486124305-104141-1-git-send-email-hare@suse.de>
 <1486124305-104141-2-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:35956 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751944AbdBCMUa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Feb 2017 07:20:30 -0500
Received: by mail-wm0-f68.google.com with SMTP id r18so4017559wmd.3
        for <linux-scsi@vger.kernel.org>; Fri, 03 Feb 2017 04:20:29 -0800 (PST)
In-Reply-To: <1486124305-104141-2-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Doug Gilberg <dgilbert@interlog.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On 02/03/2017 01:18 PM, Hannes Reinecke wrote:
> The ioctl SET_FORCE_LOW_DMA has never worked since the initial
> git check-in, and the respective setting is nowadays handled
> correctly.
> So disable it entirely.
>
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
