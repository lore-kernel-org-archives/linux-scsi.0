From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] eata: Convert eata driver as normal PCI and platform
 device drivers
Date: Mon, 29 Feb 2016 22:52:47 -0800
Message-ID: <20160301065247.GA6670@infradead.org>
References: <1456801344-3318-1-git-send-email-jiang.liu@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1456801344-3318-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Dario Ballabio <ballabio_dario@emc.com>, "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, "Ballabio, Dario" <dario.ballabio@emc.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Arthur Marsh <arthur.marsh@internode.on.net>
List-Id: linux-scsi@vger.kernel.org

Hi Jiang.

I'd love to see this patch in and abuse of the old PCI API gone.

Did you resolve the problems Arthur saw with the previous iteratons
of the patch?
