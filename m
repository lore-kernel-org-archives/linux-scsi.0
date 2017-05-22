From: "hch@lst.de" <hch@lst.de>
Subject: Re: [PATCH 02/18] bsg: Check private request size before attaching
        to a queue
Date: Mon, 22 May 2017 09:49:12 +0200
Message-ID: <20170522074912.GA2081@lst.de>
References: <20170519183016.12646-1-bart.vanassche@sandisk.com> <20170519183016.12646-3-bart.vanassche@sandisk.com> <20170521063237.GE12287@lst.de> <1495377183.3192.1.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:46704 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753043AbdEVHtO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 22 May 2017 03:49:14 -0400
Content-Disposition: inline
In-Reply-To: <1495377183.3192.1.camel@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc: "hch@lst.de" <hch@lst.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "osandov@fb.com" <osandov@fb.com>, "hare@suse.com" <hare@suse.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>

On Sun, May 21, 2017 at 02:33:05PM +0000, Bart Van Assche wrote:
> Thanks for the review comments. The cover letter should have made it to at
> least the linux-scsi mailing list since it shows up in at least one archive of
> that mailing list: https://www.spinics.net/lists/linux-scsi/msg108940.html.

Yes, I see it on the list now.  But it's missing various Cc that the
actual patches have, including that to me, which seems a bit broken.
