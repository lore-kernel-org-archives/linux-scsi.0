From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: dummy scsi read or scsi command periodically for external USB
 Hard Disk
Date: Tue, 8 Jul 2014 15:26:42 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1407081524460.1283-100000@iolanthe.rowland.org>
References: <CANudz+vNcLEJSX9L4FsPMMgJfp7rZxcryPcRmPs0-k5nB61dDg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:60088 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932116AbaGHT0p (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jul 2014 15:26:45 -0400
In-Reply-To: <CANudz+vNcLEJSX9L4FsPMMgJfp7rZxcryPcRmPs0-k5nB61dDg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: loody <miloody@gmail.com>
Cc: "Bryn M. Reeves" <bmr@redhat.com>, "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>

On Wed, 9 Jul 2014, loody wrote:

> there is one thing pop in my mind.
> if events_poll_msecs is used for media_change, shouldn't we wrap is READ10?

No.  Why should media change polling use READ(10)?  TEST UNIT READY 
does a good job of detecting media changes.

> the difference seems
> 1. change SCSI command
> 2. allocate 512 Byte for 1 sector dummy read
> the periodically trigging flow should be the same.
> 
> if you think above is possible, where we should start from?

Why do you want to make this change?

Alan Stern

