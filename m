From: "Randy.Dunlap" <rddunlap@osdl.org>
Subject: Re: usb storage traces
Date: Tue, 16 Dec 2003 09:00:43 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031216090043.49eea96a.rddunlap@osdl.org>
References: <Pine.LNX.4.44L0.0312051049040.850-100000@ida.rowland.org>
	<1070640667.12411.32.camel@patibmrh9>
	<3FD0BCED.2070205@pacbell.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:26594 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S261875AbTLPRBs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Dec 2003 12:01:48 -0500
In-Reply-To: <3FD0BCED.2070205@pacbell.net>
List-Id: linux-scsi@vger.kernel.org
To: David Brownell <david-b@pacbell.net>
Cc: p.lavarre@ieee.org, stern@rowland.harvard.edu, linux-scsi@vger.kernel.org, patmans@us.ibm.com, mdharm-scsi@one-eyed-alien.net, alex@netchip.com, jback@mpc-data.co.uk

On Fri, 05 Dec 2003 09:14:21 -0800 David Brownell <david-b@pacbell.net> wrote:

| Pat LaVarre wrote:
| >>>What is FSG?
| >>
| >>...
| >>... File-backed Storage Gadget.  
| >>It's a driver for a Linux-based USB _device_ (as opposed to _host_) that 
| >>emulates a USB Mass Storage device, using a file or block device as 
| >>backing storage in somewhat the same manner as the loop driver.
| >>... Unfortunately, ...
| > 
| > 
| > Wow, our lead FSG developer has no Linux USB _device_.
| 
| Well, he does have the "dummy_hcd" which lets him test
| on the same machine running the USB host ... I'll leave
| it to experts to contrast that with CONFIG_SCSI_DEBUG.
| 
| The driver was basically working before it hit real
| hardware.
| 
| 
| > Ouch.  Some sponsor with money should fix that.
| 
| Or Santa Claus ... ;)


or http://www.linux-usb.org/beanieForm.html

(sorry about my lateness, still catching up)
--
~Randy
MOTD:  Always include version info.
