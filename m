From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/6] cxlflash: Fix to escalate LINK_RESET also on port 1
Date: Mon, 14 Dec 2015 11:30:58 -0600
Message-ID: <B3E5E239-FD46-491B-B001-AEA78B913ACC@linux.vnet.ibm.com>
References: <1449787867-23015-1-git-send-email-ukrishn@linux.vnet.ibm.com> <1449788006-23055-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:59180 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310AbbLNRbN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Dec 2015 12:31:13 -0500
Received: from localhost
	by e36.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Mon, 14 Dec 2015 10:31:13 -0700
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
	by d03dlp02.boulder.ibm.com (Postfix) with ESMTP id 655EB3E40055
	for <linux-scsi@vger.kernel.org>; Mon, 14 Dec 2015 10:31:11 -0700 (MST)
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id tBEHVB5i29687972
	for <linux-scsi@vger.kernel.org>; Mon, 14 Dec 2015 10:31:11 -0700
Received: from d03av02.boulder.ibm.com (localhost [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id tBEHV7F7007395
	for <linux-scsi@vger.kernel.org>; Mon, 14 Dec 2015 10:31:10 -0700
In-Reply-To: <1449788006-23055-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, Brian King <brking@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>

Acked-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>

