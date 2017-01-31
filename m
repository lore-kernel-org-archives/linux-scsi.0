From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 00/10]  mpt3sas: full mq support
Date: Tue, 31 Jan 2017 11:02:43 +0100
Message-ID: <20170131100243.GA1811@lst.de>
References: <1485854760-122683-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:55240 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751394AbdAaKCq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 31 Jan 2017 05:02:46 -0500
Content-Disposition: inline
In-Reply-To: <1485854760-122683-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Sathya Prakash <sathya.prakash@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, mpt-fusionlinux.pdl@broadcom.com

On Tue, Jan 31, 2017 at 10:25:50AM +0100, Hannes Reinecke wrote:
> Hi all,
> 
> this is a patchset to enable full multiqueue support for the mpt3sas driver.
> While the HBA only has a single mailbox register for submitting commands,
> it does have individual receive queues per MSI-X interrupt and as such
> does benefit from converting it to full multiqueue support.

Explanation and numbers on why this would be beneficial, please.
We should not need multiple submissions queues for a single register
to benefit from multiple completion queues.
