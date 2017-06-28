From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 23/35] qedf: drop bus reset handler
Date: Wed, 28 Jun 2017 02:05:05 +0200
Message-ID: <20170628000505.GA14299@lst.de>
References: <1498222975-71858-1-git-send-email-hare@suse.de> <1498222975-71858-24-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:46600 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753978AbdF1AFH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Jun 2017 20:05:07 -0400
Content-Disposition: inline
In-Reply-To: <1498222975-71858-24-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

This is a clear change of behavior, so we should run it past the
maintainer.  The old behavior looks wrong, but it's probably papering
over something else..
