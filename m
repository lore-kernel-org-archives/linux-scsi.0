From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] sata_promise: Port enumeration order - SATA 150 TX4,
 SATA 300 TX4
Date: Fri, 24 Feb 2006 20:16:57 -0500
Message-ID: <43FFB009.6070403@pobox.com>
References: <43FFAE3D.7010002@physics.harvard.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:64991 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S964834AbWBYBRB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Feb 2006 20:17:01 -0500
In-Reply-To: <43FFAE3D.7010002@physics.harvard.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Milan Kupcevic <milan@physics.harvard.edu>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, trivial@rustcorp.com.au, torvalds@osdl.org

Milan Kupcevic wrote:
> From: Milan Kupcevic <milan@physics.harvard.edu>
> 
> Fix Promise SATAII 150 TX4 (PDC40518) and Promise SATA 300 TX4 
> (PDC40718-GP) wrong port enumeration order that makes it (nearly) 
> impossible to deal with boot problems using two or more drives.
> 
> Signed-off-by: Milan Kupcevic <milan@physics.harvard.edu>
> ---
> 
> The current kernel driver assumes:
> 
> port 1 - scsi3
> port 2 - scsi1
> port 3 - scsi0
> port 4 - scsi2

The current kernel driver assumes nothing, but simply exports what the 
hardware gives us.

It sounds like you are trying to patch the kernel because you received 
an incorrectly-wired board.  NAK.

	Jeff



