From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: impact of 4k sector size on the IO & FS stack
Date: Mon, 12 Mar 2007 09:40:34 -0500
Message-ID: <1173710434.3413.4.camel@mulgrave.il.steeleye.com>
References: <45F48809.2060908@emc.com>
	 <20070312081851.GA14831@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20070312081851.GA14831@infradead.org>
Sender: linux-ide-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Ric Wheeler <ric@emc.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-fsdevel@vger.kernel.org, Linux-ide <linux-ide@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2007-03-12 at 08:18 +0000, Christoph Hellwig wrote:
> The FS stack and higher levels of the I/O stack should be mostly ready.
> The S/390 DASDs are commonly used with 4k sector sizes, and we've had
> the occasional 2k sector SCSI MO device aswell.  It would be nice to
> get samples of large sector size ATA devices into the hands of developers
> to do real world testing of the whole stack.

Theoretically, we already have the capacity to verify this.  Although
not with ATA. However, since ATA uses virtually the same paths as SCSI,
we could test with variable sector SCSI devices, and SCSI does allow you
to reformat the device with different sector sizes.

James



