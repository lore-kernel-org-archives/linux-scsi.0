From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 02/18] bsg: Check private request size before attaching
        to a queue
Date: Sun, 21 May 2017 08:32:37 +0200
Message-ID: <20170521063237.GE12287@lst.de>
References: <20170519183016.12646-1-bart.vanassche@sandisk.com> <20170519183016.12646-3-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:42730 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750822AbdEUGcj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 21 May 2017 02:32:39 -0400
Content-Disposition: inline
In-Reply-To: <20170519183016.12646-3-bart.vanassche@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Omar Sandoval <osandov@fb.com>, Hannes Reinecke <hare@suse.com>, linux-block@vger.kernel.org

Hi Bart,

I think this is the wrong kind of check - while we do care about the
size of the queue, we only do it as a side effect of the queue
being able to handle REQ_OP_SCSI_IN/REQ_OP_SCSI_OUT commands.

I think we'll need a flag for those in the queue instead.

And btw, I didn't get your cover letter [0/18], did that get lost
somewhere?
