From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH v2 3/6] esp_scsi: Grant disconnect privilege for untagged
 commands
Date: Mon, 15 Oct 2018 10:04:27 +1100 (AEDT)
Message-ID: <alpine.LNX.2.21.1810150959290.10@nippy.intranet>
References: <cover.1539497520.git.fthain@telegraphics.com.au> <91b9ff9fc19ba40e3a2562171c8cd78a2ce7dc79.1539497520.git.fthain@telegraphics.com.au> <20181014154753.GA19252@infradead.org> <4719e984-2c7e-33e1-6e7c-16dea5d4f610@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4719e984-2c7e-33e1-6e7c-16dea5d4f610@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Michael Schmitz <schmitzmic@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 15 Oct 2018, Michael Schmitz wrote:

> 
> Do we really need to make that distinction?
> 

esp_reconnect() dereferences lp, so !lp has to inhibit disconnection.

At least, that's my reading. I can't see any other reason for the lp 
conditional.

-- 
