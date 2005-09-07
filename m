From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 3/5] SCSI scanning and removal fixes
Date: Wed, 07 Sep 2005 10:28:20 -0500
Message-ID: <1126106900.4823.21.camel@mulgrave>
References: <Pine.LNX.4.44L0.0507261018460.4746-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:53131 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932181AbVIGP2Y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Sep 2005 11:28:24 -0400
In-Reply-To: <Pine.LNX.4.44L0.0507261018460.4746-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Tue, 2005-07-26 at 10:20 -0400, Alan Stern wrote:
> This patch (as544) adds a private entry point to scsi_remove_device, for 
> use when callers already own the scan_mutex.  The appropriate callers are 
> modified to use the new entry point.

Oops, that's a bit of a bad of a bad bug which was introduced when
someone added the mutex to scsi_remove_device().  I'll add this too,
thanks.

James


