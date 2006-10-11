From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Rejected patch to reduce polling I/O
Date: Wed, 11 Oct 2006 09:56:09 -0500
Message-ID: <1160578569.3447.19.camel@mulgrave.il.steeleye.com>
References: <Pine.LNX.4.44L0.0610111027370.6950-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:41694 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1161067AbWJKO4O (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Oct 2006 10:56:14 -0400
In-Reply-To: <Pine.LNX.4.44L0.0610111027370.6950-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Wed, 2006-10-11 at 10:32 -0400, Alan Stern wrote:
> Andrew Morton says you rejected the patch below.  Any particular reason?

I haven't said anything at all about this patch since my comments in
June, which were basically

- could we do more to reduce flag duplication
- since the change impacts the cdrom layer we'll wait to see what the cd
maintainers want to do.

James


