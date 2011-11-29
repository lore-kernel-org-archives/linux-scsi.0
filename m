From: Josh Boyer <jwboyer@redhat.com>
Subject: Re: [PATCH] [SCSI] sd: Lower printk level for drive cache information
Date: Tue, 29 Nov 2011 10:03:16 -0500
Message-ID: <20111129150112.GA2453@zod.bos.redhat.com>
References: <20111128163053.GA24618@zod.bos.redhat.com>
 <20111129044442.GA19616@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20111129044442.GA19616@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Nov 28, 2011 at 11:44:42PM -0500, Christoph Hellwig wrote:
> On Mon, Nov 28, 2011 at 11:31:55AM -0500, Josh Boyer wrote:
> > Numerous devices don't present cache data, particularly USB sticks.  The
> > devices operate correctly despite this, so lower the printk severity to
> > KERN_NOTICE.
> 
> Do they?  The last reports on the list were for devices that didn't
> present it but actually needed cache flushes despite not having the
> cache mode page.

We've seen a number of reports for liveusb images that spit out those
printks, but seem to otherwise work fine.

Even if the devices need cache flushes, what is a typical user supposed
to do about that?  I'm not particularly tied to this patch, but there is
nothing a normal user can do with the information spit out by these
printks, so making it KERN_ERR seems excessive.

josh
> 
