From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Add release function to sd for scsi_disk structure
Date: Tue, 21 Oct 2003 09:26:54 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031021092654.A22958@infradead.org>
References: <20031018074040.GA1210@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pub234.cambridge.redhat.com ([213.86.99.234]:5386 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S263015AbTJUI0z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Oct 2003 04:26:55 -0400
Received: from hch by phoenix.infradead.org with local (Exim 4.22)
	id 1ABrqw-000603-BK
	for linux-scsi@vger.kernel.org; Tue, 21 Oct 2003 09:26:54 +0100
Content-Disposition: inline
In-Reply-To: <20031018074040.GA1210@beaverton.ibm.com>; from andmike@us.ibm.com on Sat, Oct 18, 2003 at 12:40:41AM -0700
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Sat, Oct 18, 2003 at 12:40:41AM -0700, Mike Anderson wrote:
> This patch is against 2.6.0-test8.
> 
> This patch removes the delay in calling device_del on the sdev struct
> device during a surprise removal event. Reference counting functions for
> sd's scsi_disk structure where also added to fix issues of unregistering
> when a sd is open.
> 
> I have tested this patch using scsi_debug with differnt combinations of
> adds / removes. I mounted both partitioned and un-partitioned sd disks,
> remove the host, and then did a umount. The ref count debug output shows
> the objects staying in place prior to the umount and cleaning up once
> the umount is called.

This looks like a reasonable bandaid until the block layer is fixed.  

