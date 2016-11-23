From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] hpsa: fix uninitialized variable
Date: Wed, 23 Nov 2016 08:20:37 +0100
Message-ID: <c5642905-7e06-318b-b97a-3df26760a79e@suse.de>
References: <1479827138-2211-1-git-send-email-hare@suse.de>
 <yq1vavfw52u.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49175 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932707AbcKWHVE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 23 Nov 2016 02:21:04 -0500
In-Reply-To: <yq1vavfw52u.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Hannes Reinecke <hare@suse.com>

On 11/22/2016 10:57 PM, Martin K. Petersen wrote:
>>>>>> "Hannes" == Hannes Reinecke <hare@suse.de> writes:
> 
> Hannes> With the recent patch to hpsa this warning is issued:
> Hannes> drivers/scsi/hpsa.c: In function 'hpsa_slave_alloc':
> Hannes> drivers/scsi/hpsa.c:2033:5: error: 'sd' may be used
> Hannes> uninitialized in this function [-Werror=maybe-uninitialized]
> 
> I amended your original patch.
> 
Ta.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
