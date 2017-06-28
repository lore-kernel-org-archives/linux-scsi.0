From: Chad Dupuis <chad.dupuis@cavium.com>
Subject: Re: [PATCH 19/28] qedf: drop bus reset handler
Date: Wed, 28 Jun 2017 11:05:21 -0400 (EDT)
Message-ID: <alpine.OSX.2.00.1706281102250.1017@n5106mn2lfm2r1.qlogic.org>
References: <1498638316-44420-1-git-send-email-hare@suse.de> <1498638316-44420-20-git-send-email-hare@suse.de> <20170628135858.GI1268@lst.de> <alpine.OSX.2.00.1706281003560.920@n5127mncfb42q1.qlogic.org> <20170628143716.GB2359@lst.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam01on0063.outbound.protection.outlook.com ([104.47.34.63]:12864
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751580AbdF1PFn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Jun 2017 11:05:43 -0400
In-Reply-To: <20170628143716.GB2359@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>


On Wed, 28 Jun 2017, 10:37am, Christoph Hellwig wrote:

> 
> sg_reset / SG_SCSI_RESET are designed to escalatae to to the bigger
> hammers if the method isn't implemented or doesn't succeed.
> 
> Use the -N / --no-esc option to disable that.  I wish that behavior had
> been the default from the beginning, but we can't fix that anymore.
> 

Yeah, for a sg_reset prespective that would be the better behavior.  I 
removed the bus_reset handler and used the --no-esc parameter which causes 
sg_reset to behave more reasonably:

# sg_reset -b --no-esc /dev/sdj
sg_reset: reset (for value=0x102) may not be available

Given this I don't have an objection to this patch.

Tested-by: Chad Dupuis <chad.dupuis@cavium.com>
