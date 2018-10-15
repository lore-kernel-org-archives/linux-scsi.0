From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH v2 3/6] esp_scsi: Grant disconnect privilege for untagged
 commands
Date: Mon, 15 Oct 2018 13:45:01 +1100 (AEDT)
Message-ID: <alpine.LNX.2.21.1810151342150.10@nippy.intranet>
References: <cover.1539497520.git.fthain@telegraphics.com.au> <91b9ff9fc19ba40e3a2562171c8cd78a2ce7dc79.1539497520.git.fthain@telegraphics.com.au> <20181014154753.GA19252@infradead.org> <alpine.LNX.2.21.1810151004440.10@nippy.intranet>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.21.1810151004440.10@nippy.intranet>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 15 Oct 2018, Finn Thain wrote:

> On Sun, 14 Oct 2018, Christoph Hellwig wrote:
> 
> > > +	*p++ = IDENTIFY(lp && (tp->flags & ESP_TGT_DISCONNECT), lun);
> > 
> > I think lp should always be non-NULL here.
> > 
> 
> It's not clear from Documentation/scsi/scsi_mid_low_api.txt, but I guess 
> that's true for scanning of targets.
> 
> Is it true in general that queuecommand for a device will not occur 
> before its slave_alloc and not after its slave_destroy invocation?
> 
> (I'm thinking of queuecommand via the other command submission paths, 
> like ioctl.)
> 

Nevermind. From a closer reading of the Documentation, I see that it is 
true in general.

-- 
