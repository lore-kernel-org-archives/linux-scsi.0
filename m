From: <Shyam_Iyer@Dell.com>
Subject: RE: [PATCH 1/1] [Bugme-new] [Bug 9133] New: aacraid driver fails withDell PowerEdge Expandable RAID Controller 3/Di
Date: Fri, 2 Nov 2007 15:42:10 +0530
Message-ID: <46A00B48CC54E4468EF6911F877AC4CAE2AAB7@blrx3m10.blr.amer.dell.com>
References: <bug-9133-10286@http.bugzilla.kernel.org/><20071008104741.5a0ecebf.akpm@linux-foundation.org><AE4F746F2AECFC4DA4AADD66A1DFEF01EE6699@otce2k301.adaptec.com><20071008153027.10fd15df.akpm@linux-foundation.org> <AE4F746F2AECFC4DA4AADD66A1DFEF01F955E1@otce2k301.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ausc60ps301.us.dell.com ([143.166.148.206]:40004 "EHLO
	ausc60ps301.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981AbXKBKWA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Nov 2007 06:22:00 -0400
Content-class: urn:content-classes:message
In-Reply-To: <AE4F746F2AECFC4DA4AADD66A1DFEF01F955E1@otce2k301.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: mark_salyzyn@adaptec.com, linux-scsi@vger.kernel.org
Cc: hawk@pld-linux.org, akpm@linux-foundation.org


>As reported in http://bugzilla.kernel.org/show_bug.cgi?id=9133 it was
discovered that the PERC line of controllers lacked a key 64 bit
ScatterGather 
>capable SCSI pass-through function. The adapters are still capable of
64 bit ScatterGather I/O commands, but these two can not be mixed. 

Can't this be implemented? Now, we are imposing a performance hit on
consumers investing on more that 4G memory. 

-Shyam
