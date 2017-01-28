From: "hch@lst.de" <hch@lst.de>
Subject: Re: [PATCH 14/18] scsi: remove __scsi_alloc_queue
Date: Sat, 28 Jan 2017 09:23:32 +0100
Message-ID: <20170128082332.GA4728@lst.de>
References: <1485365126-23210-1-git-send-email-hch@lst.de> <1485365126-23210-15-git-send-email-hch@lst.de> <1485539862.4267.17.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:35903 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751176AbdA1IXw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 28 Jan 2017 03:23:52 -0500
Content-Disposition: inline
In-Reply-To: <1485539862.4267.17.camel@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc: "hch@lst.de" <hch@lst.de>, "axboe@fb.com" <axboe@fb.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "snitzer@redhat.com" <snitzer@redhat.com>, "j-nomura@ce.jp.nec.com" <j-nomura@ce.jp.nec.com>

On Fri, Jan 27, 2017 at 05:58:02PM +0000, Bart Van Assche wrote:
> Since __scsi_init_queue() modifies data in the Scsi_Host structure, have you
> considered to add the declaration for this function to <scsi/scsi_host.h>?
> If you want to keep this declaration in <scsi/scsi_transport.h> please add a
> direct include of that header file to drivers/scsi/scsi_lib.c such that the
> declaration remains visible to the compiler if someone would minimize the
> number of #include directives in SCSI header files.

Feel free to send an incremental patch either way.  In the long run
I'd really like to kill off __scsi_init_queue and remove the transport
BSG queue abuse of SCSI internals, though.
