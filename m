From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [LSF/MM TOPIC NOTES] x86 ZONE_DMA love
Date: Fri, 27 Apr 2018 09:28:22 -0700
Message-ID: <20180427162822.GE8161@bombadil.infradead.org>
References: <20180426215406.GB27853@wotan.suse.de>
 <20180427053556.GB11339@infradead.org>
 <20180427161456.GD27853@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180427161456.GD27853@wotan.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org, mhocko@kernel.org, cl@linux.com, Jan Kara <jack@suse.cz>, matthew@wil.cx, x86@kernel.org, luto@amacapital.net, martin.petersen@oracle.com, jthumshirn@suse.de, broonie@kernel.org, Juergen Gross <jgross@suse.com>, linux-spi@vger.kernel.org, Joerg Roedel <joro@8bytes.org>, linux-scsi@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>, linux-kernel@vger.kernel.org, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Apr 27, 2018 at 04:14:56PM +0000, Luis R. Rodriguez wrote:
> > Not really.  We have unchecked_isa_dma to support about 4 drivers,
> 
> Ah very neat:
> 
>   * CONFIG_CHR_DEV_OSST - "SCSI OnStream SC-x0 tape support"

That's an upper level driver, like cdrom, disk and regular tapes.

>   * CONFIG_SCSI_ADVANSYS - "AdvanSys SCSI support"

If we ditch support for the ISA boards, this can go away.

>   * CONFIG_SCSI_AHA1542 - "Adaptec AHA1542 support"

Probably true.

>   * CONFIG_SCSI_ESAS2R - "ATTO Technology's ExpressSAS RAID adapter driver"

That's being set to 0.

You missed BusLogic.c and gdth.c
