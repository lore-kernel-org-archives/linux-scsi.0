From: Andrew Donnellan <andrew.donnellan@au1.ibm.com>
Subject: Re: [PATCH 6/6] cxlflash: Enable device id for future IBM CXL adapter
Date: Mon, 14 Dec 2015 14:47:58 +1100
Message-ID: <566E3BEE.9070307@au1.ibm.com>
References: <1449787867-23015-1-git-send-email-ukrishn@linux.vnet.ibm.com>
 <1449788087-23282-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:51959 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233AbbLNDtD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Dec 2015 22:49:03 -0500
Received: from localhost
	by e23smtp03.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <andrew.donnellan@au1.ibm.com>;
	Mon, 14 Dec 2015 13:48:59 +1000
Received: from d23relay08.au.ibm.com (d23relay08.au.ibm.com [9.185.71.33])
	by d23dlp03.au.ibm.com (Postfix) with ESMTP id 296273578054
	for <linux-scsi@vger.kernel.org>; Mon, 14 Dec 2015 14:48:56 +1100 (EST)
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by d23relay08.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id tBE3mT3h25100498
	for <linux-scsi@vger.kernel.org>; Mon, 14 Dec 2015 14:48:37 +1100
Received: from d23av01.au.ibm.com (localhost [127.0.0.1])
	by d23av01.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id tBE3mM8J018399
	for <linux-scsi@vger.kernel.org>; Mon, 14 Dec 2015 14:48:23 +1100
In-Reply-To: <1449788087-23282-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Uma Krishnan <ukrishn@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, Brian King <brking@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>

On 11/12/15 09:54, Uma Krishnan wrote:
> From: Manoj Kumar <manoj@linux.vnet.ibm.com>
>
> This drop enables a future card with a device id
> of 0x0600 to be recognized by the cxlflash driver.
> No card specific programming has been added. These
> card specific changes will be staged in later.
>
> Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>

Without the card-specific code, how does the driver behave if the new 
card is plugged in?


Andrew

-- 
Andrew Donnellan              Software Engineer, OzLabs
andrew.donnellan@au1.ibm.com  Australia Development Lab, Canberra
+61 2 6201 8874 (work)        IBM Australia Limited

