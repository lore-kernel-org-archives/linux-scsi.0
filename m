From: Olaf Hering <olh@suse.de>
Subject: Re: [linux-usb-devel] 2.6.11-rc3-bk5, oops in scsi_try_bus_reset
Date: Thu, 3 Mar 2005 13:32:09 +0100
Message-ID: <20050303123209.GA2255@suse.de>
References: <20050302143413.GA26585@suse.de> <Pine.LNX.4.44L0.0503021718570.7267-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Received: from ns.suse.de ([195.135.220.2]:6629 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S261601AbVCCMcP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Mar 2005 07:32:15 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0503021718570.7267-100000@ida.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net

 On Wed, Mar 02, Alan Stern wrote:

> This is a known bug in the way the SCSI midlayer interacts with the driver
> model core.  It's not related to usb-storage or the patch you've been
> trying out.  You can unblock the rmmod process by unplugging the device.

you are right, happens also with the vanilla kernel.
