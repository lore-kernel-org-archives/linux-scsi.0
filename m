From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [PATCH] sd: Optimal I/O size is in bytes, not sectors
Date: Wed, 20 Jan 2016 10:19:57 -0600
Message-ID: <2AF2F1CF-C649-44B8-A592-BB81F5FE6367@linux.vnet.ibm.com>
References: <1453305683-22424-1-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:48155 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934015AbcATQX0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Jan 2016 11:23:26 -0500
Received: from localhost
	by e32.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Wed, 20 Jan 2016 09:20:38 -0700
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
	by d03dlp01.boulder.ibm.com (Postfix) with ESMTP id 875C1C4005A
	for <linux-scsi@vger.kernel.org>; Wed, 20 Jan 2016 09:08:40 -0700 (MST)
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u0KGKU9W19005642
	for <linux-scsi@vger.kernel.org>; Wed, 20 Jan 2016 09:20:30 -0700
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u0KGKT1e008183
	for <linux-scsi@vger.kernel.org>; Wed, 20 Jan 2016 09:20:29 -0700
In-Reply-To: <1453305683-22424-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, borntraeger@de.ibm.com

Reviewed-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com> 

