From: Dominik Brodowski <linux@dominikbrodowski.net>
Subject: Re: [PATCH 5/8] pcmcia: allow PCMCIA support independent of the
 architecture
Date: Sun, 14 Oct 2018 07:42:52 +0200
Message-ID: <20181014054252.GA24103@light.dominikbrodowski.net>
References: <20181013151016.31674-1-hch@lst.de>
 <20181013151016.31674-6-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181013151016.31674-6-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>, Matt Porter <mporter@kernel.crashing.org>, Alexandre Bounine <alex.bou9@gmail.com>, linux-kbuild@vger.kernel.org, linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
List-Id: linux-scsi@vger.kernel.org

On Sat, Oct 13, 2018 at 05:10:13PM +0200, Christoph Hellwig wrote:
> There is nothing architecture specific in the PCMCIA core, so allow
> building it everywhere.  The actual host controllers will depend on ISA,
> PCI or a specific SOC.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good to me, though I'm interested on any subtle (build) breakage when
this gets exposure in -next. Will you push this patch upstream directly, or
should it go in via the pcmcia tree? If it is the former, feel free to add

	Acked-by: Dominik Brodowski <linux@dominikbrodowski.net>


Thanks,
	Dominik
