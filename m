From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 0/3] scsi_dh: switch to scsi_execute_req_flags()
Date: Tue, 1 Nov 2016 15:41:56 +0100
Message-ID: <20161101144156.GA17827@lst.de>
References: <1477936770-106687-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:53717 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S966458AbcKAOmA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 1 Nov 2016 10:42:00 -0400
Content-Disposition: inline
In-Reply-To: <1477936770-106687-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org

A little warning: scsi_execute_req_flags grew a new argument in the block
tree to be able to specify the request-only flags.  So any of these
patches would create a (mostly harmless) conflict in linux-next.
