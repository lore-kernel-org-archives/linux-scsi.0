From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-usb-devel] [2.6-test] Bug in usb-storage or scsi?
Date: Fri, 12 Sep 2003 15:59:13 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0309121556520.2323-100000@ida.rowland.org>
References: <1063312953.3347.24.camel@patehci2>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:6916 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S261813AbTILT7O (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Sep 2003 15:59:14 -0400
In-Reply-To: <1063312953.3347.24.camel@patehci2>
List-Id: linux-scsi@vger.kernel.org
To: Pat LaVarre <p.lavarre@ieee.org>
Cc: patmans@us.ibm.com, mdharm-usb@one-eyed-alien.net, usb-storage@one-eyed-alien.net, linux-scsi@vger.kernel.org

On 11 Sep 2003, Pat LaVarre wrote:

> > From: 	Alan Stern <stern@rowland.harvard.edu>
> > ...
> > (Apparently the commands don't present a
> > problem for sr.c.)
> 
> sr.c shows this problem by getting the wrong answer.
> 
> sr.c is getting cd->device->writeable wrong for all the seven-or-so mmc
> writable profiles except dvd-ram.

Getting a wrong answer isn't quite as bad as crashing the peripheral's 
firmware.  My proposed solution is meant to attack the problems of USB 
mass storage devices that crash when asked to report MODE-SENSE page 8, 
possible also when asked for page 0x3f.

Alan Stern

