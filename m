From: Christoph Hellwig <hch@lst.de>
Subject: Re: properly communicate queue limits to the DMA layer
Date: Wed, 5 Jun 2019 21:24:05 +0200
Message-ID: <20190605192405.GA18243@lst.de>
References: <20190605190836.32354-1-hch@lst.de> <591cfa1e-fecb-7d00-c855-3b9eb8eb8a2a@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <591cfa1e-fecb-7d00-c855-3b9eb8eb8a2a@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>, Sebastian Ott <sebott@linux.ibm.com>, Sagi Grimberg <sagi@grimberg.me>, Max Gurtovoy <maxg@mellanox.com>, Bart Van Assche <bvanassche@acm.org>, Ulf Hansson <ulf.hansson@linaro.org>, Alan Stern <stern@rowland.harvard.edu>, Oliver Neukum <oneukum@suse.com>, linux-block@vger.kernel.org, linux-rdma@vger.kernel.org, linux-mmc@vger.kernel.org, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, megaraidlinux.pdl@broadcom.com, MPT-FusionLinux.pdl@broadcom.com, linux-hyperv@vger.kernel.org, linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Jun 05, 2019 at 01:17:15PM -0600, Jens Axboe wrote:
> Since I'm heading out shortly and since I think this should make
> the next -rc, I'll tentatively queue this up.

The SCSI bits will need a bit more review, and possibly tweaking
fo megaraid and mpt3sas.  But they are really independent of the
other patches, so maybe skip them for now and leave them for Martin
to deal with.
