From: Asdo <asdo@shiftmail.org>
Subject: Re: LSI SAS changes SCSI address and by-path on hot-swap
Date: Fri, 05 Mar 2010 12:12:07 +0100
Message-ID: <4B90E707.8040105@shiftmail.org>
References: <4B8FE5F2.2040506@shiftmail.org>
 <1267770172.8894.24.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from blade3.isti.cnr.it ([194.119.192.19]:51675 "EHLO
	BLADE3.ISTI.CNR.IT" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755258Ab0CELMn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Mar 2010 06:12:43 -0500
Received: from conversionlocal.isti.cnr.it by mx.isti.cnr.it
 (PMDF V6.5-b2 #31825) id <01NKE1D50G1SBOUM3K@mx.isti.cnr.it> for
 linux-scsi@vger.kernel.org; Fri, 05 Mar 2010 12:12:06 +0100
In-reply-to: <1267770172.8894.24.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

James Bottomley wrote:
> [CUT]
> The thing you want is the port-3.0.  If you look in sysfs at this:
>
> ls /sys/class/sas_port/port-3\:0/device
>
> Mine contains phy-3:4  Showing this disk is actually connected to phy 4
> of the output device (as the HBA counts).
>
>   
WONDERFUL!!
Thanks for replying.
I cannot check right now on my system, maybe next week, but I trust this 
will work...
Thanks again
A.
