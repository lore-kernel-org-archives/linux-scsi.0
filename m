From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 00/10]  mpt3sas: full mq support
Date: Tue, 7 Feb 2017 14:19:09 +0100
Message-ID: <20170207131909.GH19247@lst.de>
References: <1485854760-122683-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:40607 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754342AbdBGNTM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 7 Feb 2017 08:19:12 -0500
Content-Disposition: inline
In-Reply-To: <1485854760-122683-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Sathya Prakash <sathya.prakash@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, mpt-fusionlinux.pdl@broadcom.com

Patch 1-7 look fine to me with minor fixups, and I'd love to see
them go into 4.11.  The last one looks really questionable,
and 8 and 9 will need some work so that the MPT passthrough ioctls
either go away or make use of struct request and the block layer
and SCSI infrastructure.
