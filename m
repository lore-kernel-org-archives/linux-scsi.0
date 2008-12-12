From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Bug 12188] Corsair Flash Voyager USB Stick not working
Date: Fri, 12 Dec 2008 10:30:26 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0812120949440.2504-100000@iolanthe.rowland.org>
References: <20081212073814.0223410800C@picon.linux-foundation.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:34636 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756824AbYLLPa2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Dec 2008 10:30:28 -0500
In-Reply-To: <20081212073814.0223410800C@picon.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugme-daemon@bugzilla.kernel.org, SCSI development list <linux-scsi@vger.kernel.org>
Cc: paul@purecodes.org

On Thu, 11 Dec 2008 bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=12188

> ------- Comment #4 from paul@purecodes.org  2008-12-11 23:38 -------
> Isn't there a way to fix it so that the Corsair Flash Voyager owners don't have
> to reboot the machine or rebuild the kernel of a machine where they want to use
> the memory stick?
> Would be a pity. And would be great if it was possible to fix it.

Would anybody object if the default value for scsi_inq_timeout was 
increased?  There is at least one USB device for which the current 5 
seconds is known to be too small.

Windows XP uses 20 seconds (for USB mass-storage devices, anyway -- I 
don't know about other bus types).  Is there any reason not to make 20 
the default?

Alan Stern

