From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [usb-storage] Malfunctioning USB stick
Date: Thu, 13 May 2004 14:09:29 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0405131408110.651-100000@ida.rowland.org>
References: <200405131818.55271.oliver@neukum.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:3588 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S264358AbUEMSJa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 May 2004 14:09:30 -0400
In-Reply-To: <200405131818.55271.oliver@neukum.org>
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oliver@neukum.org>
Cc: USB development list <linux-usb-devel@lists.sourceforge.net>, usb-storage@lists.one-eyed-alien.net, linux-scsi@vger.kernel.org

On Thu, 13 May 2004, Oliver Neukum wrote:

> Hi,
> 
> this stick is acting up.
> I just mounted it and got (no disconnection physically):

It looks like some sort of I/O problem reading the partition table.  What 
do you get with verbose usb-storage debugging enabled?

Alan Stern

