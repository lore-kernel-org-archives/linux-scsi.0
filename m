From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: How to disconnect a SCSI device without crashing SLES8?
Date: Fri, 4 Feb 2005 13:51:37 -0800
Message-ID: <20050204215137.GD11087@us.ibm.com>
References: <267988DEACEC5A4D86D5FCD780313FBB041F82F3@exch-03.noida.hcltech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from e2.ny.us.ibm.com ([32.97.182.142]:7875 "EHLO e2.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S266478AbVBDVxX (ORCPT
	<rfc822;Linux-scsi@vger.kernel.org>); Fri, 4 Feb 2005 16:53:23 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e2.ny.us.ibm.com (8.12.10/8.12.10) with ESMTP id j14LrK7J011478
	for <Linux-scsi@vger.kernel.org>; Fri, 4 Feb 2005 16:53:20 -0500
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j14LrKQ7273624
	for <Linux-scsi@vger.kernel.org>; Fri, 4 Feb 2005 16:53:20 -0500
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11/8.12.11) with ESMTP id j14LrK7H025416
	for <Linux-scsi@vger.kernel.org>; Fri, 4 Feb 2005 16:53:20 -0500
Content-Disposition: inline
In-Reply-To: <267988DEACEC5A4D86D5FCD780313FBB041F82F3@exch-03.noida.hcltech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Rajat  Jain, Noida" <rajatj@noida.hcltech.com>
Cc: eraskin@paslists.com, Linux-scsi@vger.kernel.org

Rajat  Jain, Noida [rajatj@noida.hcltech.com] wrote:
> Linux 2.6 ????? Uhh .... I thought you did not wanted to REBOOT the
> system???? 
> 
> 
> The command syntax is same. Devices can be removed using the following
> command:
> 
> echo "scsi remove-single-device <h> <b> <t> <l>" > /proc/scsi/scsi
> 
> where the variables are host, bus (channel), target (scsi id) and lun. 
> 

on 2.6 you can use the sysfs attributes to add and delete devices. echo
"1" > scsi/devices/1:0:0:0/delete to delete a device. echo "- - -" >
class/scsi_host/host0/scan to scan a host. You can alter the "-" wild
cards if you want to scan a smaller set of targets / luns . Also using
this scan method allows a report luns command to be sent out.

-andmike
--
Michael Anderson
andmike@us.ibm.com

