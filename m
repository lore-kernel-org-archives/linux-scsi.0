From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Weird I/O errors with USB hard drive not remounting filesystem
 readonly
Date: Tue, 24 Nov 2009 15:13:01 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0911241510590.2881-100000@iolanthe.rowland.org>
References: <20091124195607.GC16662@quack.suse.cz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:34690 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932921AbZKXUMz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Nov 2009 15:12:55 -0500
In-Reply-To: <20091124195607.GC16662@quack.suse.cz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: Boaz Harrosh <bharrosh@panasas.com>, tmhikaru@gmail.com, Kernel development list <linux-kernel@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, SCSI development list <linux-scsi@vger.kernel.org>, linux-ext4@vger.kernel.org

On Tue, 24 Nov 2009, Jan Kara wrote:

>   After digging in block layer code, it's as we suspected:
> In case of host error DID_ERROR (which is our case), scsi request is
> retried iff it is not a FAILFAST request which is set if bio is doing
> readahead... So this is explained and everything behaves as it should.
> Thanks everybody involved :).

Okay, very good.  There remains the question of the disturbing error
messages in the system log.  Should they be supressed for FAILFAST
requests?

Alan Stern

