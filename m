From: Chris Snook <csnook@redhat.com>
Subject: Re: Performance problems with 3ware 9500S-4LP and 2.6.25-rc3
Date: Tue, 26 Feb 2008 13:33:36 -0500
Message-ID: <47C45B80.6090907@redhat.com>
References: <20080226174314.GA30767@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:42751 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756430AbYBZSdr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Feb 2008 13:33:47 -0500
In-Reply-To: <20080226174314.GA30767@skl-net.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>
Cc: adam radford <aradford@gmail.com>, Tony Battersby <tonyb@cybernetics.com>, =?ISO-8859-1?Q?Johannes_W=F6rner?= <johannes.woerner@tuebingen.mpg.de>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

Andre Noll wrote:
> we are experiencing massive performance problems with two of our
> Linux servers that contain 3ware controllers on a Tyan mainboard and
> a couple of 1T disks.
> 
> During the daily cron job that uses rsync to sync a 500G file system
> from another machine to the raid on the 3ware controller the load
> jumps up, and the machine becomes sluggish as hell. For example, an
> ssh login to that machine takes minutes to complete and ldap becomes
> unreliable while the rsync job is running. Even Nagios complains
> about the machine being down while rsync is running.

You're putting your box under astronomical load.  This is generally 
regarded as a bad idea, regardless of how well your storage controller 
is performing.  Can you measure the single-threaded throughput (say, 
coping one huge file, and then syncing) to give us a baseline 
performance figure?  rsync will happily peg your box, your network, and 
your cat if you let it.

	-- Chris
