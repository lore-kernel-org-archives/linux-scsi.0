From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [patch 1/1] Whitelist-Entry (FORCELUN) for SGS Thomson Microelectronics Cytronix 6in1 card reader in scsi_devinfo.c
Date: Wed, 9 Mar 2005 08:05:36 -0800
Message-ID: <20050309160536.GA26597@us.ibm.com>
References: <200503090903.j2993vjp022052@shell0.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from e6.ny.us.ibm.com ([32.97.182.146]:15028 "EHLO e6.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S261652AbVCIQFs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Mar 2005 11:05:48 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e6.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id j29G5gHe031209
	for <linux-scsi@vger.kernel.org>; Wed, 9 Mar 2005 11:05:42 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j29G5gnA069684
	for <linux-scsi@vger.kernel.org>; Wed, 9 Mar 2005 11:05:42 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11/8.12.11) with ESMTP id j29G5gkA000880
	for <linux-scsi@vger.kernel.org>; Wed, 9 Mar 2005 11:05:42 -0500
Content-Disposition: inline
In-Reply-To: <200503090903.j2993vjp022052@shell0.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@osdl.org
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, mail@hboeck.de

On Wed, Mar 09, 2005 at 01:03:32AM -0800, akpm@osdl.org wrote:
> 
> From: Hanno Boeck <mail@hboeck.de>
> 
> I have a usb-cardreader here that needs some FORCELUN-entries in
> scsi_devinfo.c.
> 

Hanno -

Instead of the patch, try running with CONFIG_SCSI_MULTI_LUN enabled.

-- Patrick Mansfield
