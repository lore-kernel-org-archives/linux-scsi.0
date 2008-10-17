From: Joel Becker <Joel.Becker@oracle.com>
Subject: Re: [PATCH] [ConfigFS]: Allow symbolic links from a SysFS struct
	kobject source.
Date: Fri, 17 Oct 2008 12:39:47 -0700
Message-ID: <20081017193947.GC5633@mail.oracle.com>
References: <1224226555.5556.279.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:64111 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755513AbYJQTlv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Oct 2008 15:41:51 -0400
Content-Disposition: inline
In-Reply-To: <1224226555.5556.279.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>, Linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>, SCST-Devel <scst-devel@lists.sourceforge.net>, Alan Stern <stern@rowland.harvard.edu>, Andrew Morton <akpm@osdl.org>, Christoph Hellwig <hch@infradead.org>

On Thu, Oct 16, 2008 at 11:55:55PM -0700, Nicholas A. Bellinger wrote:
> Hi Joel, Greg and Co,
> 
> Here is the the first working code for allowing configfs to handle
> symlinks from sysfs struct kobject based code.  Here is the commit:
> passing struct kobject into generic target_core_mod subsystem plugins
> for locating struct block_device and struct scsi_device..  

NAK.

As Greg said, this just doesn't work.  Don't go down this path.

Joel

-- 

"I always thought the hardest questions were those I could not answer.
 Now I know they are the ones I can never ask."
			- Charlie Watkins

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
