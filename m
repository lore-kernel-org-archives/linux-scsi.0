From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: Exemple of code for cmd " scsi start "
Date: Mon, 15 Sep 2003 09:18:18 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030915091818.A31706@beaverton.ibm.com>
References: <004801c390bd$55cca700$f8e4a7c8@bsb.virtua.com.br> <3F64E3DA.4090900@mageos.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.131]:51708 "EHLO
	e33.co.us.ibm.com") by vger.kernel.org with ESMTP id S261526AbTIOQSn
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Sep 2003 12:18:43 -0400
Content-Disposition: inline
In-Reply-To: <3F64E3DA.4090900@mageos.com>; from philippe.aubry1@mageos.com on Sun, Sep 14, 2003 at 11:55:38PM +0200
List-Id: linux-scsi@vger.kernel.org
To: phil <philippe.aubry1@mageos.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Sun, Sep 14, 2003 at 11:55:38PM +0200, phil wrote:
> 
> Hello,
> I search an exemple in C for send a command to a disk, the scsi command 
>   i need is a start command.
> Where can i find a exemple with source code.

For user level code:

http://www.torque.net/sg/#Utilities:%20sg_utils%20and%20sg3_utils

Check out sg_start.c.

Kernel code - drivers/kernel/sd.c uses START_STOP, other code in sd.c and
scsi_scan.c use various SCSI commands.

-- Patrick Mansfield
