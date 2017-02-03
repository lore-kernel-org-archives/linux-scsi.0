From: Johannes Thumshirn <jth@kernel.org>
Subject: Re: [PATCHv2 5/6] sg: use standard lists for sg_requests
Date: Fri, 3 Feb 2017 13:40:26 +0100
Message-ID: <98ffb03e-6cf6-2de6-ebb0-1c0613969cdc@kernel.org>
References: <1486124305-104141-1-git-send-email-hare@suse.de>
 <1486124305-104141-6-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35327 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752169AbdBCMk3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Feb 2017 07:40:29 -0500
Received: by mail-wm0-f65.google.com with SMTP id u63so4113379wmu.2
        for <linux-scsi@vger.kernel.org>; Fri, 03 Feb 2017 04:40:29 -0800 (PST)
In-Reply-To: <1486124305-104141-6-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Doug Gilberg <dgilbert@interlog.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>


On 02/03/2017 01:18 PM, Hannes Reinecke wrote:
> 'Sg_request' is using a private list implementation; convert it
> to standard lists.
>
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
[..]

>   
>   static bool sg_is_valid_dxfer(sg_io_hdr_t *hp)
>   {
> -	switch (dxfer_direction) {
> +	switch (hp->dxfer_direction) {

And here it is
