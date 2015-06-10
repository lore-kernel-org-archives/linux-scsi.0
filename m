From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH v6] cxlflash: Base support for IBM CXL Flash Adapter
Date: Wed, 10 Jun 2015 07:23:18 -0500
Message-ID: <55782C36.4030506@linux.vnet.ibm.com>
References: <1433888152-7360-1-git-send-email-mrochs@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e17.ny.us.ibm.com ([129.33.205.207]:40561 "EHLO
	e17.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753171AbbFJMXZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Jun 2015 08:23:25 -0400
Received: from /spool/local
	by e17.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Wed, 10 Jun 2015 08:23:24 -0400
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id EF27CC90043
	for <linux-scsi@vger.kernel.org>; Wed, 10 Jun 2015 08:14:28 -0400 (EDT)
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t5ACNLud45940934
	for <linux-scsi@vger.kernel.org>; Wed, 10 Jun 2015 12:23:21 GMT
Received: from d01av04.pok.ibm.com (localhost [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t5ACNKm3010378
	for <linux-scsi@vger.kernel.org>; Wed, 10 Jun 2015 08:23:21 -0400
In-Reply-To: <1433888152-7360-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, nab@linux-iscsi.org, hch@infradead.org
Cc: mikey@neuling.org, imunsie@au1.ibm.com, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

Looks good.

Reviewed-by: Brian King <brking@linux.vnet.ibm.com>

-Brian

-- 
Brian King
Power Linux I/O
IBM Linux Technology Center


