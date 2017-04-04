From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCHv4 1/8] scsi_error: count medium access timeout only
        once per EH run
Date: Tue, 4 Apr 2017 16:05:49 +0200
Message-ID: <20170404140549.GA23337@lst.de>
References: <1491314581-73795-1-git-send-email-hare@suse.de> <1491314581-73795-2-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:52273 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754111AbdDDOFv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 4 Apr 2017 10:05:51 -0400
Content-Disposition: inline
In-Reply-To: <1491314581-73795-2-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, Lawrence Obermann <loberman@redhat.com>, Benjamin Block <bblock@linux.vnet.ibm.com>, Steffen Maier <maier@linux.vnet.ibm.com>, Hannes Reinecke <hare@suse.com>

NAK - don't overload ->eh_action for two entirely different purposes.
