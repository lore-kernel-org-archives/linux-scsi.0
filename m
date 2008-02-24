From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH 2/2] SCSI tape: show options currently set in sysfs
Date: Sun, 24 Feb 2008 14:23:13 -0800
Message-ID: <20080224142313.43ecbdcd.randy.dunlap@oracle.com>
References: <alpine.LSU.1.00.0802242220350.5772@kai.makisara.local>
	<alpine.LSU.1.00.0802242227410.5772@kai.makisara.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:44623 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753472AbYBXWXy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 24 Feb 2008 17:23:54 -0500
In-Reply-To: <alpine.LSU.1.00.0802242227410.5772@kai.makisara.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: linux-scsi@vger.kernel.org

On Sun, 24 Feb 2008 22:29:12 +0200 (EET) Kai Makisara wrote:

>  Documentation/scsi/st.txt |    7 ++++++-

> Index: linux-2.6.25-rc2-q/Documentation/scsi/st.txt
> ===================================================================
> --- linux-2.6.25-rc2-q.orig/Documentation/scsi/st.txt
> +++ linux-2.6.25-rc2-q/Documentation/scsi/st.txt
> @@ -133,6 +133,11 @@ the defaults set by the user. The value 
>  file 'dev' contains the device numbers corresponding to this device. The links
>  'device' and 'driver' point to the SCSI device and driver entries.
>  
> +Each directory acontains also the entry 'options' which shows the currently

                  also contains the entry 'options'

> +enabled driver and mode options. The value in the file is a bit mask where the
> +bit definitions are the same as those used with MTSETDRVBUFFER in setting the
> +options.
> +
>  A link named 'tape' is made from the SCSI device directory to the class
>  directory corresponding to the mode 0 auto-rewind device (e.g., st0). 


---
~Randy
