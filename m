From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC PATCH 3/3] block: add queue idle timer
Date: Tue, 15 May 2012 10:39:34 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1205151037500.1796-100000@iolanthe.rowland.org>
References: <1337071697-30920-4-git-send-email-ming.m.lin@intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:45566 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932880Ab2EOOjf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 May 2012 10:39:35 -0400
In-Reply-To: <1337071697-30920-4-git-send-email-ming.m.lin@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Lin Ming <ming.m.lin@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, 15 May 2012, Lin Ming wrote:

> Add an idle timer that is set to some suitable timeout and would be
> added when the queue first goes empty. If nothing has happened during
> the timeout interval, then the queue is suspended.

You don't need to create an idle timer for runtime PM support; the 
runtime PM framework already has such a timer.  Read 
Documentation/power/runtime_pm.txt, especially the parts describing 
pm_runtime_autosuspend() and related functions.

Alan Stern

