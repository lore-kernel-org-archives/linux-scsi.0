From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv6,2/5] scsi: Export blacklist flags to sysfs
Date: Wed, 25 Oct 2017 09:22:17 +0200
Message-ID: <312e3d67-add5-17ae-1aa7-fd0a17cc5c40@suse.de>
References: <1506954397-2237-3-git-send-email-hare@suse.de>
 <59EFED5A.5050209@rock-chips.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37887 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932109AbdJYHW2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 25 Oct 2017 03:22:28 -0400
In-Reply-To: <59EFED5A.5050209@rock-chips.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jeffy <jeffy.chen@rock-chips.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On 10/25/2017 03:48 AM, jeffy wrote:
> Hi guys,
> 
> maybe we need to add the generated scsi_devinfo_tbl.c into
> drivers/scsi/.gitignore :)
> 
Indeed, maybe.
So here's your chance to get a patch upstream :-)

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
