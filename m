From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 3/6] esp_scsi: Grant disconnect privilege for untagged
 commands
Date: Sun, 14 Oct 2018 08:47:53 -0700
Message-ID: <20181014154753.GA19252@infradead.org>
References: <cover.1539497520.git.fthain@telegraphics.com.au>
 <91b9ff9fc19ba40e3a2562171c8cd78a2ce7dc79.1539497520.git.fthain@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <91b9ff9fc19ba40e3a2562171c8cd78a2ce7dc79.1539497520.git.fthain@telegraphics.com.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

> +	*p++ = IDENTIFY(lp && (tp->flags & ESP_TGT_DISCONNECT), lun);

I think lp should always be non-NULL here.
