From: Greg KH <greg@kroah.com>
Subject: Re: START-STOP under Linux 2.4
Date: Wed, 9 Apr 2003 17:06:16 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030410000616.GB3379@kroah.com>
References: <20030402093236.A15801@one-eyed-alien.net> <Pine.LNX.4.44L0.0304021339530.17468-200000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.104]:31968 "EHLO e4.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S263884AbTDIXyS (for <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Apr 2003 19:54:18 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0304021339530.17468-200000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Wed, Apr 02, 2003 at 01:49:15PM -0500, Alan Stern wrote:
> Greg:
> 
> This patch for 2.4.21-pre6 (a backport from 2.5) removes a source of
> problems for many usb-storage devices by replacing a START-STOP command,
> used to determine if the drive media is loaded, with a TEST-UNIT-READY.  
> In the past people have handled this by creating entries in unusual_devs.h
> with the US_FL_START_STOP flag; now that should no longer be necessary.

Applied, thanks.

greg k-h
