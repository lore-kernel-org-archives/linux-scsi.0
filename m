From: Srihari Vijayaraghavan <harisri@internode.on.net>
Subject: Re: [linux-usb-devel] Fw: [BUG] USB Storage OOPS and a D state process in 2.6.10
Date: Thu, 6 Jan 2005 21:38:24 +1100
Message-ID: <200501062138.25049.harisri@internode.on.net>
References: <Pine.LNX.4.44L0.0501051039250.635-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.adl2.internode.on.net ([203.16.214.181]:23815 "EHLO
	smtp1.adl2.internode.on.net") by vger.kernel.org with ESMTP
	id S262806AbVAFKf1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Jan 2005 05:35:27 -0500
In-Reply-To: <Pine.LNX.4.44L0.0501051039250.635-100000@ida.rowland.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@steeleye.com>, USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>

On Thursday 06 January 2005 02:50, Alan Stern wrote:
> ...
> Srihari, can you try reproducing this after rebuilding the usb-storage
> driver with CONFIG_USB_STORAGE_DEBUG=y?

Alan,

Sure, I shall try to trigger this bug with the debug option.

(But I am afraid it would take a couple of days, as that USB peripheral 
belongs to a friend, who has a need for it ATM, and I shall borrow it off 
him, when it is available.)

Thanks.
Hari
