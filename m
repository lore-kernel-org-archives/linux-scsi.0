From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: PATCH: (as33b) Remove /proc/scsi directory in scsi_remove_host()
Date: Thu, 12 Jun 2003 14:58:58 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030612215858.GB3281@beaverton.ibm.com>
References: <20030612065122.GA1877@beaverton.ibm.com> <Pine.LNX.4.44L0.0306121653140.709-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.132]:9150 "EHLO e34.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S265004AbTFLVnY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Jun 2003 17:43:24 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0306121653140.709-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Christoph Hellwig <hch@infradead.org>, SCSI development list <linux-scsi@vger.kernel.org>

Alan,
	This looks good. In scsi-misc-2.5 SHT has been removed so there
	will need to be a little name sync up. 

	I also had a patch that I was working on that removed the users
	of "->present" and just left the procfs users. This might be a
	good one to add on top of this patch.

	We still have the issue outside of what this patch was trying
	to address with the proc_read/proc_write functions racing with
	the remove_proc_entry, but in previous statements this will
	currently be left as is for this obsolete interface.

-andmike
--
Michael Anderson
andmike@us.ibm.com

