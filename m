From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] [ConfigFS]: Allow symbolic links from a SysFS struct kobject source.
Date: Fri, 17 Oct 2008 05:32:52 -0600
Message-ID: <20081017113252.GV15064@parisc-linux.org>
References: <1224226555.5556.279.camel@haakon2.linux-iscsi.org> <20081017074453.GA4850@kroah.com> <1224231739.5556.303.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1224231739.5556.303.camel@haakon2.linux-iscsi.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Greg KH <greg@kroah.com>, Joel Becker <joel.becker@oracle.com>, LKML <linux-kernel@vger.kernel.org>, Linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>, SCST-Devel <scst-devel@lists.sourceforge.net>, Alan Stern <stern@rowland.harvard.edu>, Andrew Morton <akpm@osdl.org>, Christoph Hellwig <hch@infradead.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Oct 17, 2008 at 01:22:18AM -0700, Nicholas A. Bellinger wrote:
> This of course means that non TYPE_DISK of struct scsi_device would need
> to appear under /sys/ to be referenced using the symlink method..  I
> know that drivers/scsi/sr.c currently does not show up under /sys..

Hmm?

$ ls -l /sys/block/sr0/
total 0
lrwxrwxrwx 1 root root    0 2008-10-17 07:30 bdi -> ../../class/bdi/11:0
-r--r--r-- 1 root root 4096 2008-10-17 07:30 capability
-r--r--r-- 1 root root 4096 2008-10-17 07:30 dev
lrwxrwxrwx 1 root root    0 2008-10-17 07:30 device -> ../../devices/pci0000:00/0000:00:1f.1/host3/target3:0:0/3:0:0:0
drwxr-xr-x 2 root root    0 2008-10-17 07:30 holders
drwxr-xr-x 2 root root    0 2008-10-17 07:30 power
drwxr-xr-x 3 root root    0 2008-10-17 07:30 queue
-r--r--r-- 1 root root 4096 2008-10-17 07:30 range
-r--r--r-- 1 root root 4096 2008-10-17 07:30 removable
-r--r--r-- 1 root root 4096 2008-10-17 07:30 ro
-r--r--r-- 1 root root 4096 2008-10-17 07:30 size
drwxr-xr-x 2 root root    0 2008-10-17 07:30 slaves
-r--r--r-- 1 root root 4096 2008-10-17 07:30 stat
lrwxrwxrwx 1 root root    0 2008-10-17 07:30 subsystem -> ../../block
-rw-r--r-- 1 root root 4096 2008-10-17 07:30 uevent

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
