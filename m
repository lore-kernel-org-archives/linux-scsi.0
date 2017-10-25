From: jeffy <jeffy.chen@rock-chips.com>
Subject: Re: [PATCHv6,2/5] scsi: Export blacklist flags to sysfs
Date: Wed, 25 Oct 2017 15:40:23 +0800
Message-ID: <59F03FE7.30803@rock-chips.com>
References: <1506954397-2237-3-git-send-email-hare@suse.de> <59EFED5A.5050209@rock-chips.com> <312e3d67-add5-17ae-1aa7-fd0a17cc5c40@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from regular1.263xmail.com ([211.150.99.132]:38758 "EHLO
        regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751686AbdJYHkb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Oct 2017 03:40:31 -0400
In-Reply-To: <312e3d67-add5-17ae-1aa7-fd0a17cc5c40@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

Hi Hannes,

On 10/25/2017 03:22 PM, Hannes Reinecke wrote:
> On 10/25/2017 03:48 AM, jeffy wrote:
>> Hi guys,
>>
>> maybe we need to add the generated scsi_devinfo_tbl.c into
>> drivers/scsi/.gitignore :)
>>
> Indeed, maybe.
> So here's your chance to get a patch upstream :-)
>
Ok, will do that :)

> Cheers,
>
> Hannes
>
