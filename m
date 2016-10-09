From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] scsi: replace wrong device handler name for CLARiiON
        arrays
Date: Sun, 9 Oct 2016 17:19:55 +0200
Message-ID: <20161009151955.GB20037@lst.de>
References: <20161007161957.6042-1-xose.vazquez@gmail.com> <612033e6-1caa-30e8-b4f2-8cf3fd5190c7@suse.de> <1475968905.2892.11.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:54284 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751498AbcJIPT5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 9 Oct 2016 11:19:57 -0400
Content-Disposition: inline
In-Reply-To: <1475968905.2892.11.camel@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>
Cc: Hannes Reinecke <hare@suse.de>, Xose Vazquez Perez <xose.vazquez@gmail.com>, Christoph Hellwig <hch@lst.de>, Christophe Varoqui <christophe.varoqui@opensvc.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, SCSI ML <linux-scsi@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>

On Sun, Oct 09, 2016 at 07:21:45AM +0800, James Bottomley wrote:
> Actually, should we replace?  Aren't there older arrays still bearing
> the clariion name, so we should have these entries in addition?

The changed string isn't the inquiry vendor string, but the DH driver
name it is mapped to.  And the driver for the clariion arrays is indeed
emc, even if the inquity data shows DGC.
