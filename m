From: Christoph Hellwig <hch@infradead.org>
Subject: Re: impact of 4k sector size on the IO & FS stack
Date: Mon, 12 Mar 2007 14:57:27 +0000
Message-ID: <20070312145727.GA31815@infradead.org>
References: <45F48809.2060908@emc.com> <20070312081851.GA14831@infradead.org> <45F5677C.40602@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <45F5677C.40602@garzik.org>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Christoph Hellwig <hch@infradead.org>, Ric Wheeler <ric@emc.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-fsdevel@vger.kernel.org, Linux-ide <linux-ide@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Mar 12, 2007 at 10:45:16AM -0400, Jeff Garzik wrote:
> Christoph Hellwig wrote:
> >the occasional 2k sector SCSI MO device aswell.  It would be nice to
> >get samples of large sector size ATA devices into the hands of developers
> >to do real world testing of the whole stack.
> 
> "hands of developers" meaning you specifically?  :)

No.  I probably wouldn't have time to deal with it aswell.

> I've had a 512b-logical/1K-physical ATA test drive for a few months now, 
> and another couple arrived today.

Ok, that's exactly what I meant.

