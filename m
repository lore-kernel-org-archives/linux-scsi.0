From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: SCSI dynamic power management
Date: Mon, 19 Nov 2007 11:00:24 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0711191057200.4806-100000@iolanthe.rowland.org>
References: <4741AFEA.8000408@emulex.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:49509 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753529AbXKSQAZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Nov 2007 11:00:25 -0500
In-Reply-To: <4741AFEA.8000408@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <James.Smart@Emulex.Com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Mon, 19 Nov 2007, James Smart wrote:

> Also, don't forget that you need to sequence spin-up. A jbod tower with
> multiple drives all spinning up concurrently can overload the power
> supply. Most towers avoid this at power-on by having drive jumpers
> sequence the drives. This is a hard nut to crack as it requires some
> notion of physical packaging. When I worked on this in the past, the
> only reasonable approach was to sequence based on target id.

What happens during an ordinary system resume?  Don't the drives all 
get spun-up concurrently then?  Or does the sd_start_stop_device() 
routine wait until the disk is fully spun-up before returning?

Alan Stern

