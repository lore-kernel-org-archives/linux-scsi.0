From: Andries Brouwer <aebr@win.tue.nl>
Subject: Re: [patch for playing] 2.5.65 patch to support > 256 disks
Date: Fri, 28 Mar 2003 19:41:53 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030328184153.GA11941@win.tue.nl>
References: <200303211056.04060.pbadari@us.ibm.com> <200303261629.34868.pbadari@us.ibm.com> <20030327091854.GY30908@suse.de> <200303280904.41797.pbadari@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200303280904.41797.pbadari@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Jens Axboe <axboe@suse.de>, Nick Piggin <piggin@cyberone.com.au>, Andrew Morton <akpm@digeo.com>, dougg@torque.net, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, Mar 28, 2003 at 09:04:41AM -0800, Badari Pulavarty wrote:

> 2) Instead of allocating hd_struct structure for all possible partitions,
> why not allocated them dynamically, as we see a partition ? This
> way we could (in theory) support more than 16 partitions, if needed.

This is what I plan to do.
Of course you are welcome to do it first.

Andries

