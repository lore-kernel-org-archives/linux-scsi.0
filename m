From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH] scsi: Eliminate compile warning in ibmvfc.c
Date: Mon, 17 Nov 2008 10:56:16 -0600
Message-ID: <4921A230.9010508@linux.vnet.ibm.com>
References: <18707.45838.704492.589455@cargo.ozlabs.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:37610 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751620AbYKQQ4t (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Nov 2008 11:56:49 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e3.ny.us.ibm.com (8.13.1/8.13.1) with ESMTP id mAHGuf7M022356
	for <linux-scsi@vger.kernel.org>; Mon, 17 Nov 2008 11:56:41 -0500
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mAHGumQg158776
	for <linux-scsi@vger.kernel.org>; Mon, 17 Nov 2008 11:56:48 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id mAHGumUk031119
	for <linux-scsi@vger.kernel.org>; Mon, 17 Nov 2008 11:56:48 -0500
In-Reply-To: <18707.45838.704492.589455@cargo.ozlabs.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paul Mackerras <paulus@samba.org>
Cc: linux-scsi@vger.kernel.org, sfr@canb.auug.org.au

Paul Mackerras wrote:
> Recent gcc (4.3.2) gives this compile warning on
> drivers/scsi/ibmvscsi/ibmvfc.o:
> 
>   CC      drivers/scsi/ibmvscsi/ibmvfc.o
> .../drivers/scsi/ibmvscsi/ibmvfc.c: In function 'ibmvfc_reset_device':
> .../drivers/scsi/ibmvscsi/ibmvfc.c:1630: warning: 'evt' may be used uninitialized in this function

There is a patch already queued up in scsi-misc to fix this as well:

http://git.kernel.org/gitweb.cgi?p=linux/kernel/git/jejb/scsi-misc-2.6.git;a=commitdiff;h=eaf5d80a9e7fae4de7f899fd5efc8f3e9f49efa6

-Brian

-- 
Brian King
Linux on Power Virtualization
IBM Linux Technology Center


