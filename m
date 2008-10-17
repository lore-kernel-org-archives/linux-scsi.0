From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] [ConfigFS]: Allow symbolic links from a SysFS struct
	kobject source.
Date: Fri, 17 Oct 2008 00:44:53 -0700
Message-ID: <20081017074453.GA4850@kroah.com>
References: <1224226555.5556.279.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1224226555.5556.279.camel@haakon2.linux-iscsi.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Joel Becker <joel.becker@oracle.com>, LKML <linux-kernel@vger.kernel.org>, Linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>, SCST-Devel <scst-devel@lists.sourceforge.net>, Alan Stern <stern@rowland.harvard.edu>, Andrew Morton <akpm@osdl.org>, Christoph Hellwig <hch@infradead.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Oct 16, 2008 at 11:55:55PM -0700, Nicholas A. Bellinger wrote:
> Hi Joel, Greg and Co,
> 
> Here is the the first working code for allowing configfs to handle
> symlinks from sysfs struct kobject based code.  Here is the commit:
> passing struct kobject into generic target_core_mod subsystem plugins
> for locating struct block_device and struct scsi_device..  

Um, no.

You are trying to create symlinks dynamically across superblocks and
mount points?  As one of your #warning states, this isn't possible to do
correctly, nor is it even a good idea.

So I'd have to reject this patch, sorry.

What is the problem you are attempting to solve here?

thanks,

greg k-h
