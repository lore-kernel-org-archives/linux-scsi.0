From: Christoph Hellwig <hch@infradead.org>
Subject: Re: 3.15-mw:  Oops Workqueue: writeback bdi_writeback_workfn
 (flush-8:16)  RIP: e030:[<ffffffff814c6bc1>]  [<ffffffff814c6bc1>]
 kobject_put+0x11/0x70
Date: Mon, 14 Apr 2014 12:00:11 -0700
Message-ID: <20140414190011.GA31204@infradead.org>
References: <1299097701.20140412133431@eikelenboom.it>
 <20140414113015.GA4765@infradead.org>
 <20140414145700.74825388@jlaw-desktop.mno.stratus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140414145700.74825388@jlaw-desktop.mno.stratus.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Joe Lawrence <joe.lawrence@stratus.com>
Cc: Sander Eikelenboom <linux@eikelenboom.it>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Apr 14, 2014 at 02:57:00PM -0400, Joe Lawrence wrote:
> I hit a similar crash last week on a franken-kernel here (3.14 + scsi
> misc + qlogic patches + out of tree drivers + terriblethingsIknow).  I
> think there is one other similar use-after-free that's been in place
> for a while now:

Yes, that looks the same.  I'll fix it and prepare a patch that
consolidates this duplicate code while at it.
