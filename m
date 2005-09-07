From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 2/5] SCSI scanning and removal fixes
Date: Wed, 07 Sep 2005 10:26:16 -0500
Message-ID: <1126106776.4823.18.camel@mulgrave>
References: <Pine.LNX.4.44L0.0507261012340.4746-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:50059 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932174AbVIGP0T (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Sep 2005 11:26:19 -0400
In-Reply-To: <Pine.LNX.4.44L0.0507261012340.4746-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Tue, 2005-07-26 at 10:18 -0400, Alan Stern wrote:
> This patch (as543) adds a private entry point to scsi_scan_target, for use
> when the caller already owns the scan_mutex, and updates the kerneldoc for
> that routine (which was badly out-of-date).  It converts scsi_scan_channel
> to use the new entry point.  Lastly, it modifies scsi_get_host_dev to make 
> it acquire the scan_mutex, necessary since the routine adds a new 
> scsi_device even if it doesn't do any actual scanning.

This looks fine, thanks,

James


