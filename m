From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] RESEND: SCSI, libata: add support for ATA_16 commands to libata ATAPI devices
Date: Fri, 2 Feb 2007 09:11:16 +0000
Message-ID: <20070202091116.GB27907@infradead.org>
References: <200701021935.07840.liml@rtr.ca> <200701311346.26644.liml@rtr.ca> <45C1356B.6000907@gmail.com> <45C1377F.6070001@rtr.ca> <45C138E8.1040706@gmail.com> <45C1A4BD.3030909@garzik.org> <45C1A823.30008@gmail.com> <45C1B8D4.1070209@garzik.org> <1170342565.3388.4.camel@mulgrave.il.steeleye.com> <45C24BC5.6060305@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <45C24BC5.6060305@torque.net>
Sender: linux-ide-owner@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Jeff Garzik <jeff@garzik.org>, Tejun Heo <htejun@gmail.com>, Mark Lord <liml@rtr.ca>, Linux IDE <linux-ide@vger.kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Feb 01, 2007 at 03:21:25PM -0500, Douglas Gilbert wrote:
> My point is that the linux block layer and scsi mid
> level should get out of the business of putting hard
> limits place. Why?

Both of them never have been in the business of putting hard
limits in place.  We currently have a hard limit in place
because the storage for the cdb is allocated statically.  This
is a desin decision done more than ten years ago that we're
slowly trying to fix.  Second we have a facility to allow
LLDDs limit the size of the cdb they receive.  It's not
mandatory in any way, but very useful for those "smart"
HBAs that can't deal with larger dbs due to hardware limitations.

