From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 07/13] SCSI: export scsi_eh_finish_cmd() and	scsi_eh_flush_done_q()
Date: Mon, 23 Jan 2006 09:36:53 +0000
Message-ID: <20060123093653.GB9157@infradead.org>
References: <11379893764141-git-send-email-htejun@gmail.com> <1138001160.2977.14.camel@laptopd505.fenrus.org> <43D491DA.4020603@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <43D491DA.4020603@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Arjan van de Ven <arjan@infradead.org>, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, albertcc@tw.ibm.com, linux-ide@vger.kernel.org, jgarzik@pobox.com
List-Id: linux-scsi@vger.kernel.org

On Mon, Jan 23, 2006 at 05:20:42PM +0900, Tejun Heo wrote:
> Arjan van de Ven wrote:
> > On Mon, 2006-01-23 at 13:09 +0900, Tejun Heo wrote:
> > 
> >>Export two SCSI EH command handling functions.  To be used by libata EH.
> > 
> > since these are pretty much internal, can we make these _GPL exports?
> > 
> 
> It's SCSI developers' decision.  I chose EXPORT_SYMBOL because all other
> exported symbols in scsi_error.c were using it.  James?

These are internal functions.  If we're going to export them at all then
as _GPL (which is grossly misnamed and should be _INTERNAL)
