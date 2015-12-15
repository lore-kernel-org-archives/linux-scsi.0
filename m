From: Manoj Kumar <manoj@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 3/6] cxlflash: Removed driver date print
Date: Tue, 15 Dec 2015 15:04:04 -0600
Message-ID: <56708044.4060008@linux.vnet.ibm.com>
References: <1450126293-47440-1-git-send-email-ukrishn@linux.vnet.ibm.com>
 <1450127193-48109-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Reply-To: manoj@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:54041 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932443AbbLOVD6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Dec 2015 16:03:58 -0500
Received: from localhost
	by e32.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <manoj@linux.vnet.ibm.com>;
	Tue, 15 Dec 2015 14:03:57 -0700
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id A59ED19D8026
	for <linux-scsi@vger.kernel.org>; Tue, 15 Dec 2015 13:51:59 -0700 (MST)
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id tBFL3s5E27656428
	for <linux-scsi@vger.kernel.org>; Tue, 15 Dec 2015 14:03:54 -0700
Received: from d03av03.boulder.ibm.com (localhost [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id tBFL3rmZ004400
	for <linux-scsi@vger.kernel.org>; Tue, 15 Dec 2015 14:03:54 -0700
In-Reply-To: <1450127193-48109-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Uma Krishnan <ukrishn@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, Brian King <brking@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Daniel Axtens <dja@ozlabs.au.ibm.com>

On 12/14/2015 3:06 PM, Uma Krishnan wrote:
> Having a date for the driver requires it to be updated quite
> often. Removing the date which is not necessary. Also made
> use of the existing symbol to print the driver name.
>
> Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
> ---

Acked-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>

