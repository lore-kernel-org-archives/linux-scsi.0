From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Deadlock in usb-storage error handling
Date: Thu, 20 Mar 2014 12:34:01 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1403201233150.858-100000@iolanthe.rowland.org>
References: <1395331764.2244.16.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:42526 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758547AbaCTQeC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Mar 2014 12:34:02 -0400
In-Reply-To: <1395331764.2244.16.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andreas Reis <andreas.reis@gmail.com>, USB list <linux-usb@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>

On Thu, 20 Mar 2014, James Bottomley wrote:

> OK, so I think we have three things to do
> 
>      1. Investigate SCSI and fix it's abort state problem that's causing
>         it not to send the abort second time around
>      2. Fix usb-storage to fail a reset it can't do (i.e. device reset
>         with outstanding commands)
>      3. Find out why we're sending a spurious request sense.
> 
> I can look at 1 and 3 if you want to take 2.

It's a deal!  Thanks for your help.

Alan Stern

