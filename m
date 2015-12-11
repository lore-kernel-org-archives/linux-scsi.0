From: Manoj Kumar <manoj@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/6] cxlflash: Fix to avoid virtual LUN failover failure
Date: Fri, 11 Dec 2015 08:53:29 -0600
Message-ID: <566AE369.3070809@linux.vnet.ibm.com>
References: <1449787867-23015-1-git-send-email-ukrishn@linux.vnet.ibm.com>
 <1449788029-23093-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Reply-To: manoj@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e17.ny.us.ibm.com ([129.33.205.207]:50582 "EHLO
	e17.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753683AbbLKOxe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Dec 2015 09:53:34 -0500
Received: from localhost
	by e17.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <manoj@linux.vnet.ibm.com>;
	Fri, 11 Dec 2015 09:53:33 -0500
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id 8673BC90043
	for <linux-scsi@vger.kernel.org>; Fri, 11 Dec 2015 09:41:36 -0500 (EST)
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id tBBErRQ431195388
	for <linux-scsi@vger.kernel.org>; Fri, 11 Dec 2015 14:53:27 GMT
Received: from d01av04.pok.ibm.com (localhost [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id tBBErOfk015013
	for <linux-scsi@vger.kernel.org>; Fri, 11 Dec 2015 09:53:26 -0500
In-Reply-To: <1449788029-23093-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Uma Krishnan <ukrishn@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, Brian King <brking@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>

On 12/10/2015 4:53 PM, Uma Krishnan wrote:
> From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
> To remedy this scenario, provide feedback back to the application on
> virtual LUN creation as to which ports the LUN may be accessed. LUN's
> spanning both ports are candidates for a retry in a presence of an I/O
> failure.
>
> Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>

Acked-by: Manoj Kumar <manoj@linux.vnet.ibm.com>



