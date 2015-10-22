From: Manoj Kumar <manoj@linux.vnet.ibm.com>
Subject: Re: [PATCH v6 35/37] cxlflash: Fix to avoid corrupting port selection
 mask
Date: Thu, 22 Oct 2015 12:17:54 -0500
Message-ID: <56291A42.6090504@linux.vnet.ibm.com>
References: <1445458134-63197-1-git-send-email-mrochs@linux.vnet.ibm.com>
 <1445458575-62688-1-git-send-email-mrochs@linux.vnet.ibm.com>
Reply-To: manoj@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:57436 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757459AbbJVRRr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Oct 2015 13:17:47 -0400
Received: from localhost
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <manoj@linux.vnet.ibm.com>;
	Thu, 22 Oct 2015 11:17:46 -0600
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id 2CF67C9005E
	for <linux-scsi@vger.kernel.org>; Thu, 22 Oct 2015 13:05:55 -0400 (EDT)
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t9MHHht962521558
	for <linux-scsi@vger.kernel.org>; Thu, 22 Oct 2015 17:17:43 GMT
Received: from d01av02.pok.ibm.com (localhost [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t9MHHgh5019552
	for <linux-scsi@vger.kernel.org>; Thu, 22 Oct 2015 13:17:43 -0400
In-Reply-To: <1445458575-62688-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Brian King <brking@linux.vnet.ibm.com>, Ian Munsie <imunsie@au1.ibm.com>, Daniel Axtens <dja@ozlabs.au.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Tomas Henzl <thenzl@redhat.com>, David Laight <David.Laight@ACULAB.COM>
Cc: Michael Neuling <mikey@neuling.org>, linuxppc-dev@lists.ozlabs.org

Acked-by: Manoj Kumar <manoj@linux.vnet.ibm.com>

On 10/21/2015 3:16 PM, Matthew R. Ochs wrote:
> The port selection mask of a LUN can be corrupted when the manage LUN
> ioctl (DK_CXLFLASH_MANAGE_LUN) is issued more than once for any device.

