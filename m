From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: Bugs in scsi system, need help to fix
Date: Mon, 14 Apr 2003 13:40:38 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030414204038.GF4162@beaverton.ibm.com>
References: <20030414062333.GA11487@beaverton.ibm.com> <Pine.LNX.4.44L0.0304141017580.827-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.132]:11685 "EHLO
	e34.co.us.ibm.com") by vger.kernel.org with ESMTP id S263943AbTDNU1O (for <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Apr 2003 16:27:14 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0304141017580.827-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: David Brownell <david-b@pacbell.net>, Linux SCSI list <linux-scsi@vger.kernel.org>

Alan Stern [stern@rowland.harvard.edu] wrote:
> Thanks, Mike.  Is it safe to assume that a combined fix for all these 
> problems will be posted in the next few weeks, as part of the 
> hot-unplugging development effort?

The fix for the scsi_eh_lock_done problem I am testing a patch now and
hopefully will have it out for others to test later today.

The fix / removal of scsi_check_device_busy will be part of the scsi
host remove / offline patches.

-andmike
--
Michael Anderson
andmike@us.ibm.com

