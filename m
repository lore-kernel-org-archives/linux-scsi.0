From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] scsi: fix kconfig dependency warnings for SCSI_FC_ATTRS
Date: Mon, 22 Sep 2014 09:44:59 -0700
Message-ID: <20140922164459.GA15753@infradead.org>
References: <541CC163.3080709@infradead.org>
 <20140922144213.GA28200@infradead.org>
 <20140922.115658.940423588560943657.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140922.115658.940423588560943657.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: hch@infradead.org, rdunlap@infradead.org, netdev@vger.kernel.org, linux-scsi@vger.kernel.org, jbottomley@parallels.com, anish@chelsio.com
List-Id: linux-scsi@vger.kernel.org

On Mon, Sep 22, 2014 at 11:56:58AM -0400, David Miller wrote:
> > CONFIG_SCSI_QLA_FC currently selects SCSI_FC_ATTRS, so we shouldn't
> > need this here. Also any reason not to switch that one over to a
> > depends as well?
> 
> Christoph, I understand your confusion now, in the networking tree SCSI_QLA_FC
> "depends" on SCSI_FC_ATTRS now, and this is what Randy's patches are against.

Ok.  The fixes look fine for me if you checked they make sense vs the net
tree.

Acked-by: Christoph Hellwig <hch@lst.de>
