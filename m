From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] libata: implement minimal transport template for ->eh_timed_out
Date: Sat, 18 Mar 2006 19:46:14 +0100
Message-ID: <20060318184614.GA32405@lst.de>
References: <20060318094014.GE25706@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20060318094014.GE25706@htj.dyndns.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, Andrew Morton <akpm@osdl.org>, James Bottomley <James.Bottomley@SteelEye.com>, Christoph Hellwig <hch@lst.de>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sat, Mar 18, 2006 at 06:40:14PM +0900, Tejun Heo wrote:
> SCSI midlayer has moved hostt->eh_timed_out to transport template.  As
> libata doesn't need full-blown transport support yet, implement
> minimal transport for libata.  No transport class or whatsoever, just
> empty transport template with ->eh_timed_out hook.

ok.

