From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] osdblk: a Linux block device for OSD objects
Date: Wed, 01 Apr 2009 22:05:16 -0400
Message-ID: <49D41D5C.7070601@garzik.org>
References: <20090402015455.GA14087@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:38257 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756207AbZDBCFZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Apr 2009 22:05:25 -0400
In-Reply-To: <20090402015455.GA14087@havoc.gtf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, axboe@kernel.dk, Andrew Morton <akpm@linux-foundation.org>

Jeff Garzik wrote:
> As I promised in older exofs threads, here is a client for libosd
> _other_ than exofs.  This block driver exports a single OSD object
> as a Linux block device.

It should be noted that the first handful of functions are duplicates of 
fs/exofs/osd.c; an obvious consolidation is in order.

	Jeff




