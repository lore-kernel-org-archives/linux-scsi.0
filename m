From: Christoph Hellwig <hch@infradead.org>
Subject: Re: cciss update [2/2] fixes for Steeleye Lifekeeper
Date: Thu, 14 Oct 2004 19:39:48 +0100
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20041014183948.GA12325@infradead.org>
References: <20041013212253.GB9866@beardog.cca.cpqcorp.net> <20041014083900.GB7747@infradead.org> <1097764660.2198.11.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S267319AbUJNSzN@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1097764660.2198.11.camel@mulgrave>
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Christoph Hellwig <hch@infradead.org>, mikem@beardog.cca.cpqcorp.net, Andrew Morton <akpm@osdl.org>, Jens Axboe <axboe@suse.de>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Oct 14, 2004 at 09:37:32AM -0500, James Bottomley wrote:
> I don't think so ... it's a volume you know exists but you can't get
> access to (in a shared storage configuration).  In SCSI we have two
> examples of this now:

Such a volume has been configured and set up, and although it's still
ugly I'd say it's okay.  But the patch also adds one gendisk per controller
even if no volume is set up.
