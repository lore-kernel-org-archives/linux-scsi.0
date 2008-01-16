From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: SCSI power management for AHCI
Date: Wed, 16 Jan 2008 10:21:35 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0801161020190.4431-100000@iolanthe.rowland.org>
References: <20080115201114.GA7219@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:54062 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751188AbYAPPVh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Jan 2008 10:21:37 -0500
In-Reply-To: <20080115201114.GA7219@elf.ucw.cz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-scsi@vger.kernel.org, linux-pm@lists.linux-foundation.org

On Tue, 15 Jan 2008, Pavel Machek wrote:

> Hi!
> 
> This is my first attempt at ahci autosuspend. It is _very_ hacky at
> this moment, I'll seriously need to clean it up. But it seems to work
> here.

How does this interact with Link Power Management?  Should there be 
a stronger connection between the two?

Alan Stern


