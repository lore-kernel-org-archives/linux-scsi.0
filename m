From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 1/1] 3ware 9000 disable local irqs during kmap_atomic
Date: Tue, 11 Apr 2006 14:53:43 -0400
Message-ID: <443BFB37.8080400@garzik.org>
References: <b1bc6a000604111125s74a95319m39e23598ed4755a5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:6024 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1750986AbWDKSxr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Apr 2006 14:53:47 -0400
In-Reply-To: <b1bc6a000604111125s74a95319m39e23598ed4755a5@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: adam radford <aradford@gmail.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

adam radford wrote:
> The attached patch for 2.6.17-rc2 updates the 3ware 9000 driver:
> 
> - Disable local interrupts during kmap/unmap_atomic().
> 
> Signed-off-by: Adam Radford <linuxraid@amcc.com>
> 
> James, Please apply
> 
> Thanks!
> 
> -Adam
> 
> Note: The patch is attached as an attachment, and also included
> in-line below.   The below may have line-wrap issues since I'm pasting
> into gmail.

I saw the fix go into 2.6.17-rc1-git on git-commits-head list.  Please 
check out the latest linux-2.6.git and send a patch against what's in 
there...

	Jeff



