From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] hpsa: expose enclosures
Date: Fri, 2 Dec 2016 12:41:59 +0100
Message-ID: <4f2d7544-0848-051e-65b9-af4649076c44@suse.de>
References: <1480674993-118324-1-git-send-email-hare@suse.de>
 <20161202113958.GA26885@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53487 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754527AbcLBLmC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 2 Dec 2016 06:42:02 -0500
In-Reply-To: <20161202113958.GA26885@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Don Brace <don.brace@microsemi.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On 12/02/2016 12:39 PM, Christoph Hellwig wrote:
> On Fri, Dec 02, 2016 at 11:36:33AM +0100, Hannes Reinecke wrote:
>> Some servers have a built-in enclosure which will show up on the
>> same bus as the internal physical devices. As the driver doesn't
>> differentiate here they'll be hidden from the OS.
>> This patch add a module parameter 'hpsa_expose_enclosure' which
>> will expose these enclosures.
>
> Any reason for not doing this unconditionally?
>
Backwards compability.
hpsa never did, so it _might_ be by design.
You never know :-)

I surely can make this the default if Don agrees.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
