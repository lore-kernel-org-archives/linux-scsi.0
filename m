From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] [ConfigFS]: Allow symbolic links from a SysFS struct
	kobject source.
Date: Fri, 17 Oct 2008 12:50:44 -0700
Message-ID: <1224273044.5556.353.camel@haakon2.linux-iscsi.org>
References: <1224226555.5556.279.camel@haakon2.linux-iscsi.org>
	 <20081017193947.GC5633@mail.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:42608 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751090AbYJQTuq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Oct 2008 15:50:46 -0400
In-Reply-To: <20081017193947.GC5633@mail.oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joel Becker <Joel.Becker@oracle.com>
Cc: Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>, Linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>, SCST-Devel <scst-devel@lists.sourceforge.net>, Alan Stern <stern@rowland.harvard.edu>, Andrew Morton <akpm@osdl.org>, Christoph Hellwig <hch@infradead.org>

On Fri, 2008-10-17 at 12:39 -0700, Joel Becker wrote:
> On Thu, Oct 16, 2008 at 11:55:55PM -0700, Nicholas A. Bellinger wrote:
> > Hi Joel, Greg and Co,
> > 
> > Here is the the first working code for allowing configfs to handle
> > symlinks from sysfs struct kobject based code.  Here is the commit:
> > passing struct kobject into generic target_core_mod subsystem plugins
> > for locating struct block_device and struct scsi_device..  
> 
> NAK.
> 
> As Greg said, this just doesn't work.  Don't go down this path.
> 

Fair enough, I will kill it from my tree. :-)

Thanks for your comments!

--nab



