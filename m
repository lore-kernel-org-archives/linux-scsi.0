From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: Patches to add support for Cloverleaf SCSI devices
Date: Thu, 19 Feb 2004 08:23:53 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040219082353.A30080@beaverton.ibm.com>
References: <200402191509.41289.Cyril.Plisko@CloverleafComm.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.106]:4059 "EHLO e6.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S267343AbUBSQYb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Feb 2004 11:24:31 -0500
Content-Disposition: inline
In-Reply-To: <200402191509.41289.Cyril.Plisko@CloverleafComm.COM>; from Cyril.Plisko@CloverleafComm.COM on Thu, Feb 19, 2004 at 03:09:41PM +0200
List-Id: linux-scsi@vger.kernel.org
To: Cyril Plisko <Cyril.Plisko@CloverleafComm.COM>
Cc: linux-scsi@vger.kernel.org

On Thu, Feb 19, 2004 at 03:09:41PM +0200, Cyril Plisko wrote:
> Hello,
> 
> Attached are patches for linux-2.4 and -2.6 series to add support
> for Cloverleaf SCSI devices.

Does REPORT LUN work for the device? If so you do not need a patch for
2.6.

-- Patrick Mansfield
