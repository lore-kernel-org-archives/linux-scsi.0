From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH 1/1] [Bugme-new] [Bug 9133] New: aacraid driver fails withDell PowerEdge Expandable RAID Controller 3/Di
Date: Fri, 2 Nov 2007 10:25:03 -0400
Message-ID: <AE4F746F2AECFC4DA4AADD66A1DFEF01F95A8D@otce2k301.adaptec.com>
References: <bug-9133-10286@http.bugzilla.kernel.org/><20071008104741.5a0ecebf.akpm@linux-foundation.org><AE4F746F2AECFC4DA4AADD66A1DFEF01EE6699@otce2k301.adaptec.com><20071008153027.10fd15df.akpm@linux-foundation.org> <AE4F746F2AECFC4DA4AADD66A1DFEF01F955E1@otce2k301.adaptec.com> <46A00B48CC54E4468EF6911F877AC4CAE2AAB7@blrx3m10.blr.amer.dell.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ts.adaptec.com ([162.62.93.58]:57303 "EHLO mail-gw3.adaptec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754000AbXKBOZI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Nov 2007 10:25:08 -0400
Content-class: urn:content-classes:message
In-Reply-To: <46A00B48CC54E4468EF6911F877AC4CAE2AAB7@blrx3m10.blr.amer.dell.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shyam_Iyer@Dell.com, linux-scsi@vger.kernel.org
Cc: hawk@pld-linux.org, akpm@linux-foundation.org

You, as a Dell representative, will need to address changes in Firmware
or other options for these adapters to the Adaptec representative on
site.

This patch does NOT impose a performance hit on consumers investing on
more than 4G of Memory, what it does is prevent SCSI pass-through calls
from /dev/sg, /dev/sd and the management ioctls. Many functions of the
management tools do NOT require the SCSI pass-through, as the
information FIBs continue to function. I choose drop in functionality
instead of a possible performance hit to resolve the missing Firmware
Function.

If the consumer needs the management functionality or SCSI pass-through
then they *may* affect performance by selecting the other driver
options; but one needs to sit down and actually measure this to be sure
there is a loss in their situation.

Sincerely -- Mark Salyzyn

> -----Original Message-----
> From: Shyam_Iyer@Dell.com [mailto:Shyam_Iyer@Dell.com] 
> Sent: Friday, November 02, 2007 6:12 AM
> To: Salyzyn, Mark; linux-scsi@vger.kernel.org
> Cc: hawk@pld-linux.org; akpm@linux-foundation.org
> Subject: RE: [PATCH 1/1] [Bugme-new] [Bug 9133] New: aacraid 
> driver fails withDell PowerEdge Expandable RAID Controller 3/Di
> 
> >As reported in http://bugzilla.kernel.org/show_bug.cgi?id=9133 it
> > was discovered that the PERC line of controllers lacked a key 64
> > bit ScatterGather capable SCSI pass-through function. The adapters
> > are still capable of 64 bit ScatterGather I/O commands, but these
two can not be mixed. 
> Can't this be implemented? Now, we are imposing a performance hit on
> consumers investing on more that 4G memory. 
> 
> -Shyam
