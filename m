From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 13/47] megaraid: pass in NULL scb for host reset
Date: Wed, 28 Jun 2017 20:40:38 +0200
Message-ID: <20170628184038.GA12922@lst.de>
References: <1498638793-44672-1-git-send-email-hare@suse.de> <1498638793-44672-14-git-send-email-hare@suse.de> <f5b7e09b259b22452afe1da669712af6@mail.gmail.com> <ce2005d3-420c-3920-dadc-b9d1d36c8ecc@suse.de> <5443ed26d0465a0a277ccf90fdeb1e73@mail.gmail.com> <CAHtARFFTFMaUsVZ_KuYGr3hFcTuD5sf=h2+1RM6aj8yfpwsCWQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:50939 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751541AbdF1Skk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Jun 2017 14:40:40 -0400
Content-Disposition: inline
In-Reply-To: <CAHtARFFTFMaUsVZ_KuYGr3hFcTuD5sf=h2+1RM6aj8yfpwsCWQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: adam radford <aradford@gmail.com>
Cc: Kashyap Desai <kashyap.desai@broadcom.com>, Hannes Reinecke <hare@suse.de>, Sumit Saxena <sumit.saxena@broadcom.com>, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.com>

On Wed, Jun 28, 2017 at 11:38:22AM -0700, adam radford wrote:
> LSI/Broadcom isn't the maintainer of the 3ware drivers.  See 'MAINTAINERS'.
>   Your attempts
> to remove them may get a NACK from the Maintainer since I believe there are
> still users of these controllers.

Same for the legacy megaraid driver, but we can just mark that as
orphan for now.
