From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/2] sg: factor out sg_fill_request_table()
Date: Fri, 15 Sep 2017 19:54:06 +0200
Message-ID: <20170915175406.GA8805@lst.de>
References: <1505477116-75013-1-git-send-email-hare@suse.de> <1505477116-75013-2-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:38806 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750838AbdIORyI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 15 Sep 2017 13:54:08 -0400
Content-Disposition: inline
In-Reply-To: <1505477116-75013-2-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Alexander Potapenko <glider@google.com>, Ingo Molnar <mingo@redhat.com>, Dmitry Vyukov <dvyukov@google.com>, security@kernel.org, Hannes Reinecke <hare@suse.com>

On Fri, Sep 15, 2017 at 02:05:15PM +0200, Hannes Reinecke wrote:
> Factor our sg_fill_request_table() for better readability.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.com>

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
