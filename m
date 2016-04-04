From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: [PATCH 03/14] libata-scsi: sanitize ata_gen_ata_sense()
Date: Mon, 4 Apr 2016 20:33:37 +0300
Message-ID: <5702A571.4060905@cogentembedded.com>
References: <1459763047-125551-1-git-send-email-hare@suse.de>
 <1459763047-125551-4-git-send-email-hare@suse.de>
 <57024F7B.20604@cogentembedded.com> <20160404162253.GZ7822@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:36562 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538AbcDDRdn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Apr 2016 13:33:43 -0400
Received: by mail-lb0-f181.google.com with SMTP id qe11so171264333lbc.3
        for <linux-scsi@vger.kernel.org>; Mon, 04 Apr 2016 10:33:42 -0700 (PDT)
In-Reply-To: <20160404162253.GZ7822@mtj.duckdns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Hannes Reinecke <hare@suse.de>, linux-ide@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Shaun Tancheff <shaun.tancheff@seagate.com>, Damien Le Moal <damien.lemoal@hgst.com>, linux-scsi@vger.kernel.org, Sathya Prakash <sathya.prakash@broadcom.com>, Hannes Reinecke <hare@suse.com>

On 04/04/2016 07:22 PM, Tejun Heo wrote:

>>> +	} else {
>>> +		/* Could not decode error */
>>> +		ata_dev_warn(dev, "could not decode error status 0x%x err_mask 0x%x\n",
>>
>>     "%#x" is equivalent and takes up less space.

> Oops, gmail for some reason put Sergei's messages into spam folder.

    My (dynamic) IP was even blacklisted by the Freenode's IRC servers not so 
long ago. :-)

> Hannes, can you please generate incremental patches for Sergei's
> comments?

    Don't think it's worth it. Perhaps only the comment typos...

> Thanks.

MBR, Sergei

