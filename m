From: Manoj Kumar <manoj@linux.vnet.ibm.com>
Subject: Re: [PATCH v6 37/37] cxlflash: Fix to avoid bypassing context cleanup
Date: Thu, 22 Oct 2015 13:05:30 -0500
Message-ID: <5629256A.6090105@linux.vnet.ibm.com>
References: <1445458134-63197-1-git-send-email-mrochs@linux.vnet.ibm.com>
 <1445458592-63806-1-git-send-email-mrochs@linux.vnet.ibm.com>
Reply-To: manoj@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e17.ny.us.ibm.com ([129.33.205.207]:57492 "EHLO
	e17.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990AbbJVSFW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Oct 2015 14:05:22 -0400
Received: from localhost
	by e17.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <manoj@linux.vnet.ibm.com>;
	Thu, 22 Oct 2015 14:05:22 -0400
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id 3B511C90041
	for <linux-scsi@vger.kernel.org>; Thu, 22 Oct 2015 13:53:30 -0400 (EDT)
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t9MI5III62062714
	for <linux-scsi@vger.kernel.org>; Thu, 22 Oct 2015 18:05:18 GMT
Received: from d01av02.pok.ibm.com (localhost [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t9MI5GLW029486
	for <linux-scsi@vger.kernel.org>; Thu, 22 Oct 2015 14:05:18 -0400
In-Reply-To: <1445458592-63806-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Brian King <brking@linux.vnet.ibm.com>, Ian Munsie <imunsie@au1.ibm.com>, Daniel Axtens <dja@ozlabs.au.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Tomas Henzl <thenzl@redhat.com>, David Laight <David.Laight@ACULAB.COM>
Cc: Michael Neuling <mikey@neuling.org>, linuxppc-dev@lists.ozlabs.org

Acked-by: Manoj Kumar <manoj@linux.vnet.ibm.com>

On 10/21/2015 3:16 PM, Matthew R. Ochs wrote:
> Contexts may be skipped over for cleanup in situations where contention
> for the adapter's table-list mutex is experienced in the presence of a
> signal during the execution of the release handler.

