From: Olaf Hering <olh@suse.de>
Subject: Re: [linux-usb-devel] 2.6.11-rc3-bk5, oops in scsi_try_bus_reset
Date: Mon, 14 Feb 2005 08:20:05 +0100
Message-ID: <20050214072005.GA8586@suse.de>
References: <20050210105650.GA1070@suse.de> <Pine.LNX.4.44L0.0502101002120.887-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Received: from ns.suse.de ([195.135.220.2]:64466 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S261360AbVBNHUH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Feb 2005 02:20:07 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0502101002120.887-100000@ida.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-usb-devel@lists.sourceforge.net

 On Thu, Feb 10, Alan Stern wrote:

> And Mike Anderson's response was
> 
> http://marc.theaimsgroup.com/?l=linux-scsi&m=110538854224319&w=2
> 
> His explanation was "Currently scsi_host_cancel being called from
> scsi_remove_host appears to not do anything as scsi_forget_host removes
> the devices from the list it iterates over."  I don't know whether this 
> problem has been fixed yet.

So, does anyone else know if that has been fixed, are there any patches
I can try?
Just plugging it in and out with init=/bin/bash doesnt trigger the oops.
