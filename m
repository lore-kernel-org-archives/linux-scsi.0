From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC v2 PATCH 1/4] block: add a flag to identify PM request
Date: Thu, 17 May 2012 13:46:04 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1205171345190.1169-100000@iolanthe.rowland.org>
References: <1337269686-3781-2-git-send-email-ming.m.lin@intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:47509 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757016Ab2EQRqF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 May 2012 13:46:05 -0400
In-Reply-To: <1337269686-3781-2-git-send-email-ming.m.lin@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Lin Ming <ming.m.lin@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>, Jeff Moyer <jmoyer@redhat.com>, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org

On Thu, 17 May 2012, Lin Ming wrote:

> Add a flag REQ_PM to identify the request is PM related.
> As an example, modify scsi code to use this flag.

Some systems need to use the SCSI error handler during suspend and 
resume.  You'll need to mark every command sent by the error handler 
with the REQ_PM flag.

Alan Stern

