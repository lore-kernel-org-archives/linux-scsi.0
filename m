From: Johannes Thumshirn <jth@kernel.org>
Subject: Re: [PATCHv2 4/6] sg: check for valid direction before starting the
 request
Date: Fri, 3 Feb 2017 13:36:42 +0100
Message-ID: <61297b1c-aa07-4203-d45a-3ad58ca6f495@kernel.org>
References: <1486124305-104141-1-git-send-email-hare@suse.de>
 <1486124305-104141-5-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:34824 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752169AbdBCMgp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Feb 2017 07:36:45 -0500
Received: by mail-wm0-f66.google.com with SMTP id u63so4091694wmu.2
        for <linux-scsi@vger.kernel.org>; Fri, 03 Feb 2017 04:36:44 -0800 (PST)
In-Reply-To: <1486124305-104141-5-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Doug Gilberg <dgilbert@interlog.com>, linux-scsi@vger.kernel.org, Johannes Thumshirn <jthumshirn@suse.de>, Hannes Reinecke <hare@suse.com>


On 02/03/2017 01:18 PM, Hannes Reinecke wrote:
> From: Johannes Thumshirn <jthumshirn@suse.de>
>
> Check for a valid direction before starting the request, otherwise we risk
> running into an assertion in the scsi midlayer checking for vaild requests.
>
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> Link: http://www.spinics.net/lists/linux-scsi/msg104400.html
> Reported-by: Dmitry Vyukov <dvyukov@google.com>
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
[...]

>   
> +static bool sg_is_valid_dxfer(sg_io_hdr_t *hp)
> +{
> +	switch (dxfer_direction) {

This wont build now... needs a +hp
