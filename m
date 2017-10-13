From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv6 0/5] scsi: Fixup blacklist handling
Date: Fri, 13 Oct 2017 12:06:29 +0200
Message-ID: <cd626e1c-a282-bc8a-d6ac-6002ab2294ed@suse.de>
References: <1506954397-2237-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36795 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753365AbdJMKGb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 13 Oct 2017 06:06:31 -0400
In-Reply-To: <1506954397-2237-1-git-send-email-hare@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org

On 10/02/2017 04:26 PM, Hannes Reinecke wrote:
> Hi all,
> 
> the SCSI blacklist handling seems to be rather tricky issue;
> everytime a fix is included it tends to break other devices.
> This patchset attempt to simplify the devlist handling yet again,
> but this time implementing the framework for regression testing, too.
> A patch adding a regression test to the blktest suite will follow.
> 
> As usual, comments and reviews are welcome.
> 
Martin, ping?
What is the status of this patchset?
Do you need anything from my side?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
