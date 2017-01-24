From: "hch@lst.de" <hch@lst.de>
Subject: Re: [PATCH 15/16] block: split scsi_request out of struct request
Date: Tue, 24 Jan 2017 09:09:06 +0100
Message-ID: <20170124080906.GA17018@lst.de>
References: <1485185361-29786-1-git-send-email-hch@lst.de> <1485185361-29786-16-git-send-email-hch@lst.de> <1485217979.2825.20.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:51371 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751052AbdAXIJN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 24 Jan 2017 03:09:13 -0500
Content-Disposition: inline
In-Reply-To: <1485217979.2825.20.camel@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc: "hch@lst.de" <hch@lst.de>, "axboe@fb.com" <axboe@fb.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "snitzer@redhat.com" <snitzer@redhat.com>

On Tue, Jan 24, 2017 at 12:33:13AM +0000, Bart Van Assche wrote:
> Do we perhaps need a check before the above memcpy() call whether or not
> sense == NULL?

Yes, probably.  I didn't think of the case where the caller wouldn't
pass a sense buffer.  Just curious, what's the callstack that caused
this?
