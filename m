From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [linux-usb-devel] usb-storage and Sony Handycam
Date: Mon, 10 Nov 2003 11:04:55 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031110110455.A23256@beaverton.ibm.com>
References: <20031110095914.B22518@beaverton.ibm.com> <Pine.LNX.4.44L0.0311101335310.6288-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.105]:3031 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S264057AbTKJTGT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Nov 2003 14:06:19 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0311101335310.6288-100000@ida.rowland.org>; from stern@rowland.harvard.edu on Mon, Nov 10, 2003 at 01:46:44PM -0500
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Dmitri Katchalov <dmitrik@users.sourceforge.net>, Idan Sofer <idan@idanso.dyndns.org>, ronald@kuetemeier.com, USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>

On Mon, Nov 10, 2003 at 01:46:44PM -0500, Alan Stern wrote:
> On Mon, 10 Nov 2003, Patrick Mansfield wrote:

> How could anyone attempt to find out why the reset failed?  The only 
> externally visible state is the device's response to incoming USB 
> requests.  IIRC, it simply didn't respond to the reset request.  (I'm not 
> sure about that; I may be confusing this with other devices that failed in 
> similar ways.)

I don't know, the bug report (and other logs) show:

Nov  7 00:12:19 [kernel] usb-storage: Command MODE_SENSE_10 (10 bytes)
Nov  7 00:12:19 [kernel] usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=10
Nov  7 00:12:19 [kernel] usb-storage: Status code 0; transferred 10/10
Nov  7 00:12:19 [kernel] usb-storage: -- transfer complete
Nov  7 00:12:19 [kernel] usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Nov  7 00:12:19 [kernel] usb-storage: usb_stor_bulk_transfer_buf: xfer 8 bytes
Nov  7 00:12:19 [kernel] usb-storage: Status code -75; transferred 8/8
Nov  7 00:12:19 [kernel] usb-storage: -- babble
Nov  7 00:12:19 [kernel] usb-storage: CB data stage result is 0x3
Nov  7 00:12:19 [kernel] usb-storage: -- transport indicates error, resetting
Nov  7 00:12:19 [kernel] usb-storage: usb_stor_CB_reset called
Nov  7 00:12:19 [kernel] usb-storage: usb_stor_control_msg: rq=00 rqtype=21 value=0000 index=00 len=12
Nov  7 00:12:19 [kernel] usb-storage: Soft reset failed: -32
Nov  7 00:12:19 [kernel] usb-storage: scsi cmd done, result=0x70000

-- Patrick Mansfield
