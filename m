From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: Synchronizing scsi_remove_host and the error handler
Date: Mon, 8 Aug 2005 13:06:07 -0700
Message-ID: <20050808200607.GB22773@us.ibm.com>
References: <Pine.LNX.4.44L0.0508071408370.32668-100000@netrider.rowland.org> <1123451837.5020.22.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.133]:57494 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S932247AbVHHUGt
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Aug 2005 16:06:49 -0400
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e35.co.us.ibm.com (8.12.10/8.12.9) with ESMTP id j78K6iWY567686
	for <linux-scsi@vger.kernel.org>; Mon, 8 Aug 2005 16:06:44 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by westrelay02.boulder.ibm.com (8.12.10/NCO/VERS6.7) with ESMTP id j78K6XTR197906
	for <linux-scsi@vger.kernel.org>; Mon, 8 Aug 2005 14:06:33 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id j78K6cmV002869
	for <linux-scsi@vger.kernel.org>; Mon, 8 Aug 2005 14:06:39 -0600
Content-Disposition: inline
In-Reply-To: <1123451837.5020.22.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, SCSI development list <linux-scsi@vger.kernel.org>

James Bottomley <James.Bottomley@SteelEye.com> wrote:
> On Sun, 2005-08-07 at 14:43 -0400, Alan Stern wrote:
> > What host device release method?  scsi_host_template->release is marked 
> > OBSOLETE and for use only with old-style drivers.  scsi_host_dev_release 
>                                                      ^^^^^
> This is the one I was thinking of adding to.

Is the thought here that if a LLDD provided some new scsi_host_template
function we would call this from scsi_host_dev_release?

-andmike
--
Michael Anderson
andmike@us.ibm.com
