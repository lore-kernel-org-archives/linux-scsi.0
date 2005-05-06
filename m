From: Andries Brouwer <aebr@win.tue.nl>
Subject: Re: Empty partition nodes not created (was device node issues with recent mm's and udev)
Date: Fri, 6 May 2005 10:04:37 +0200
Message-ID: <20050506080437.GE4604@pclin040.win.tue.nl>
References: <d4757e6005050219514ece0c0a@mail.gmail.com> <20050503031421.GA528@kroah.com> <20050502202620.04467bbd.rddunlap@osdl.org> <d4757e600505022118131ec083@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S261174AbVEFIEx@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <d4757e600505022118131ec083@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Joe <joecool1029@gmail.com>
Cc: "Randy.Dunlap" <rddunlap@osdl.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>, Greg KH <greg@kroah.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, May 03, 2005 at 12:18:05AM -0400, Joe wrote:
> On 5/2/05, Randy.Dunlap <rddunlap@osdl.org> wrote:
> > Could this 2.6.11.8 -stable patch fix it?
> > Subject: [04/07] partitions/msdos.c fix
> > 
> > Joe, can you test 2.6.11.8, please?
> > 
> > ---
> > ~Randy
> > 
> 
> Randy, Can't run vanilla at the moment on this setup, any way you can
> get the patch seperate?  I also don't think that will fix it because
> this is an empty, not a msdos partition.
> 
> Thanks,
> Joe

There is a misunderstanding in terminology here.
"DOS-type partition table" is for most Linux users the only type
they have ever seen. The msdos in this context does not refer
to a particular filesystem, like the fat or msdos filesystem.

In case you have a problem because you want to access this partition,
give it some nonzero type.

Andries
