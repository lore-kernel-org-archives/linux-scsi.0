From: Christoph Hellwig <hch@infradead.org>
Subject: Re: PATCH: (as33b) Remove /proc/scsi directory in scsi_remove_host()
Date: Sun, 15 Jun 2003 14:01:24 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030615140124.A9321@infradead.org>
References: <20030612065122.GA1877@beaverton.ibm.com> <Pine.LNX.4.44L0.0306121653140.709-100000@ida.rowland.org> <20030612215858.GB3281@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([195.224.96.167]:15887 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S262185AbTFOMre (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 15 Jun 2003 08:47:34 -0400
Content-Disposition: inline
In-Reply-To: <20030612215858.GB3281@beaverton.ibm.com>; from andmike@us.ibm.com on Thu, Jun 12, 2003 at 02:58:58PM -0700
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>, Christoph Hellwig <hch@infradead.org>, SCSI development list <linux-scsi@vger.kernel.org>

On Thu, Jun 12, 2003 at 02:58:58PM -0700, Mike Anderson wrote:
> 	I also had a patch that I was working on that removed the users
> 	of "->present" and just left the procfs users. This might be a
> 	good one to add on top of this patch.

Yes, certainly.

> 	We still have the issue outside of what this patch was trying
> 	to address with the proc_read/proc_write functions racing with
> 	the remove_proc_entry, but in previous statements this will
> 	currently be left as is for this obsolete interface.

This is a generic procfs problem.  We could maybe use real file operations
for the procfs files and then set the owner to the LLDD module.
But probably it's not worth the effort..
