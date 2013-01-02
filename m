From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/2] RESEND ipr: Implement block iopoll
Date: Wed, 02 Jan 2013 16:42:41 -0600
Message-ID: <50E4B7E1.9000607@linux.vnet.ibm.com>
References: <20130102182312.041361425@linux.vnet.ibm.com> <20130102182407.737530683@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e7.ny.us.ibm.com ([32.97.182.137]:56925 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752753Ab3ABWmv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Jan 2013 17:42:51 -0500
Received: from /spool/local
	by e7.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Wed, 2 Jan 2013 17:42:50 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id 85FC26E803C
	for <linux-scsi@vger.kernel.org>; Wed,  2 Jan 2013 17:42:43 -0500 (EST)
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id r02Mgh2W199364
	for <linux-scsi@vger.kernel.org>; Wed, 2 Jan 2013 17:42:44 -0500
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id r02MghdH029297
	for <linux-scsi@vger.kernel.org>; Wed, 2 Jan 2013 15:42:43 -0700
In-Reply-To: <20130102182407.737530683@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: wenxiong@linux.vnet.ibm.com
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, klebers@linux.vnet.ibm.com

This should probably have been flagged with a v2 rather than a RESEND since
it has been changed to use kstrtoul.

Acked-by: Brian King <brking@linux.vnet.ibm.com>

-- 
Brian King
Power Linux I/O
IBM Linux Technology Center


