From: Christoph Hellwig <hch@infradead.org>
Subject: Re: PATCH: (as33) Remove /proc/scsi directory in scsi_remove_host()
Date: Thu, 12 Jun 2003 07:04:45 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030612070445.A15899@infradead.org>
References: <20030521180308.GD1116@beaverton.ibm.com> <Pine.LNX.4.44L0.0306111328330.696-100000@ida.rowland.org> <20030611182323.GC1596@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([195.224.96.167]:28166 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S264752AbTFLFvD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Jun 2003 01:51:03 -0400
Content-Disposition: inline
In-Reply-To: <20030611182323.GC1596@beaverton.ibm.com>; from andmike@us.ibm.com on Wed, Jun 11, 2003 at 11:23:24AM -0700
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>, SCSI development list <linux-scsi@vger.kernel.org>

On Wed, Jun 11, 2003 at 11:23:24AM -0700, Mike Anderson wrote:
> Alan,
> 	This is bug, but I do not think this fix will work for non
> 	legacy callers. LLDDs that just use scsi_add_host and
> 	scsi_remove_host would have the remove_proc_entry called
> 	possibly too early.

Why should we care when the proc entry is remove?  The whole ->proc_info
mess is marked obsolete in 2.5 so no one should rely on it.  It's certainly
better than leaking the proc_dir_entry :)

