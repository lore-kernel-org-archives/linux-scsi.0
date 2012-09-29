From: Michael Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 07/17] be2iscsi: Fix the kernel panic in blkiopoll disable mode
Date: Sat, 29 Sep 2012 11:31:40 -0500
Message-ID: <79ADB278-10C0-401F-9E5E-F40B32502EC6@cs.wisc.edu>
References: <da282c92-f339-43bc-a13f-28e13a2420a3@CMEXHTCAS1.ad.emulex.com>
Mime-Version: 1.0 (Mac OS X Mail 6.1 \(1498\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:52687 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756618Ab2I2Qbt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 Sep 2012 12:31:49 -0400
In-Reply-To: <da282c92-f339-43bc-a13f-28e13a2420a3@CMEXHTCAS1.ad.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Soni Jose <sony.john-n@emulex.com>
Cc: linux-scsi@vger.kernel.org, Jayamohan Kallickal <jayamohan.kallickal@emulex.com>


On Sep 28, 2012, at 8:32 PM, John Soni Jose <sony.john-n@emulex.com> wrote:

> From: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
> 
> Fix kernel panic issue while running IO in blk_iopoll disable mode.

What was the bug exactly?

> Creating UNBOUND WQ for each EQ in the driver.

What is the benefit of doing this vs per hba like before?

Why WQ_UNBOUND? It seems other drivers prefer it the other way.
