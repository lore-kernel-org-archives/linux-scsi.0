From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: PATCH: (as84) Fix a mistake in scsi_proc.c
Date: 26 Sep 2003 11:06:52 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1064592414.1781.8.camel@mulgrave>
References: <Pine.LNX.4.44L0.0309261200140.5938-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:34055 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261681AbTIZQG6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Sep 2003 12:06:58 -0400
In-Reply-To: <Pine.LNX.4.44L0.0309261200140.5938-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Fri, 2003-09-26 at 11:03, Alan Stern wrote:
> I tried sending this patch to Mike Anderson a couple of times, but never
> got any response.  It's an obvious fix for a mistake in a section of code
> I sent to him last spring: an error path fails to release a mutex.
> 
> If you don't see anything wrong here, please apply it.

It's already in the scsi-misc-2.5 BK tree

http://linux-scsi.bkbits.net:8080/scsi-misc-2.5/cset@1.1239.1.2?nav=index.html|ChangeSet@-1d

James


