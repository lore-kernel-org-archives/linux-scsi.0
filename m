From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [patch] add scsi changer driver
Date: Mon, 07 Mar 2005 10:42:35 +0200
Message-ID: <1110184955.5410.1.camel@mulgrave>
References: <20050215164245.GA13352@bytesex>
	 <20050215175431.GA2896@infradead.org> <20050216143936.GA23892@bytesex>
	 <1110131725.9206.25.camel@mulgrave>  <20050307082107.GC17704@bytesex>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
In-Reply-To: <20050307082107.GC17704@bytesex>
Sender: linux-kernel-owner@vger.kernel.org
To: Gerd Knorr <kraxel@bytesex.org>
Cc: Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@osdl.org>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2005-03-07 at 09:21 +0100, Gerd Knorr wrote:
> Probably historical reasons, I havn't tracked the scsi layer changes for
> quite some time, so this might simply be a 2.6 cleanup I've missed
> because of that.  Will check ...

OK, Thanks.

> > ch_ioctl() (and the compat): since this is a new driver, can't this all
> > be done via sysfs?  That way, the user would be able to manipulate it
> > from the command line, and we'd no longer need any of the 32->64 compat
> > glue.
> 
> Well, it isn't new, it already exists for many years, just not living in
> mainline (which I finally want to change now ...).

OK, so could you look at doing the sysfs conversions?  These are
required before the driver goes in.  I can help you when I get back from
holiday (in about a week's time).

James
