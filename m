From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-usb-devel] 2.6.9-rc4mm1:badness in drivers/scsi/scsi_lib.c
Date: Mon, 18 Oct 2004 11:30:46 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0410181129520.1194-100000@ida.rowland.org>
References: <Pine.GSO.4.58.0410181447450.29704@boromir>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:8452 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S266684AbUJRPaq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Oct 2004 11:30:46 -0400
In-Reply-To: <Pine.GSO.4.58.0410181447450.29704@boromir>
List-Id: linux-scsi@vger.kernel.org
To: Mateusz.Blaszczyk@nask.pl
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, mdharm-usb@one-eyed-alien.net, linux-usb-users@lists.sourceforge.net, linux-usb-devel@lists.sourceforge.net

On Mon, 18 Oct 2004 Mateusz.Blaszczyk@nask.pl wrote:

> Hi,
> 
> After successful write on USB DVD-R writer (HP-200j), system oops's when unpluging USB device.
> Same thing with 2.6.9-rc2mm1.

Try applying this patch:

http://marc.theaimsgroup.com/?l=linux-usb-devel&m=109744234829347&q=raw

Alan Stern

