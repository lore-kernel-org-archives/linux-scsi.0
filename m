From: James.Smart@Emulex.Com
Subject: RE: [PATCH] scsi_mid_low_api doesn't mention scsi_scan_host
Date: Mon, 21 Mar 2005 17:52:36 -0500
Message-ID: <9BB4DECD4CFE6D43AA8EA8D768ED51C201AF54@xbl3.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Received: from emulex.emulex.com ([138.239.112.1]:48809 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S261977AbVCUWwm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Mar 2005 17:52:42 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: matthew@wil.cx
Cc: dgilbert@interlog.com, linux-scsi@vger.kernel.org

> Thanks for the correction.  How does this look?
> 
>  *      Notes: Only required in "hotplug initialization model" after a
>  *      successful call to scsi_host_alloc().  This function does not
>  *      scan the bus; this can be done by calling scsi_scan_host() or
>  *      in some other transport-specific way.  The LLD must set up
>  *      the transport template before calling this function 
> and may only
>  *      access the transport class data after this function 
> has been called.

a work of art :)

