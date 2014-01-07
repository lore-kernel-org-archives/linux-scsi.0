From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: Re: [PATCH 3.12 033/118] usb: xhci: Link TRB must not occur within a
 USB payload burst
Date: Tue, 7 Jan 2014 15:31:32 -0800
Message-ID: <20140107233132.GG4199@xanatos>
References: <52C32BB0.90600@gmail.com>
 <20140102191510.GA9621@xanatos>
 <52C6D9F1.9000709@gmail.com>
 <20140103195455.GA4193@xanatos>
 <52C729CE.9050307@gmail.com>
 <20140103232929.GD4193@xanatos>
 <20140107003157.GA7963@xanatos>
 <52CC014C.5060604@gmail.com>
 <063D6719AE5E284EB5DD2968C1650D6D453E1A@AcuExch.aculab.com>
 <52CC5CC0.8060504@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:24317 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753380AbaAGXb5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Jan 2014 18:31:57 -0500
Content-Disposition: inline
In-Reply-To: <52CC5CC0.8060504@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: walt <w41ter@gmail.com>
Cc: David Laight <David.Laight@ACULAB.COM>, Alan Stern <stern@rowland.harvard.edu>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linux Kernel <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Tue, Jan 07, 2014 at 12:00:00PM -0800, walt wrote:
> Okay, I used log_buf_len to make dmesg bigger and now I think I have
> the whole thing.  It's attached.

Walt, can you make sure the patch I sent you was applied?  The output
doesn't look like it is.

Sarah Sharp
