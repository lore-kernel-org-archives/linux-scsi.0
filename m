From: Christoph Hellwig <hch@lst.de>
Subject: Re: Issues with commit 34b48db6 ("block: remove artifical
	max_hw_sectors cap")
Date: Tue, 23 Dec 2014 09:31:40 +0100
Message-ID: <20141223083140.GB2303@lst.de>
References: <alpine.DEB.2.10.1412211420560.4323@tosh-p75a>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1412211420560.4323@tosh-p75a>
Sender: linux-ide-owner@vger.kernel.org
To: "Kenneth R. Crudup" <kenny@panix.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sun, Dec 21, 2014 at 02:44:20PM -0800, Kenneth R. Crudup wrote:
> 
> I had issues with my Samsung 4GB disk recently in Linus' master tree kernels,
> and have bisected it to the above commit. When doing running bonnie++ (etc.
> I get EIOs.
> 
> Some info is below, let me know if you need anything else. Is there a "quirks"
> available for this option so I may special-case this particular disk?

Looks like we need to quirk it.  Can you try to echo different limits
to the /sys/block/sdc/queue/max_hw_sectors_kb  file for the device to
find the limit
for it?

