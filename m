From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/1] ipr: ipr_test_msi() fails when running with msi-x
 enabled adapter
Date: Thu, 28 Feb 2013 12:59:35 -0600
Message-ID: <512FA917.5090203@linux.vnet.ibm.com>
References: <20130227183744.430469620@linux.vnet.ibm.com> <20130227184347.437115470@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e8.ny.us.ibm.com ([32.97.182.138]:46613 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933067Ab3B1TA2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Feb 2013 14:00:28 -0500
Received: from /spool/local
	by e8.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Thu, 28 Feb 2013 14:00:27 -0500
Received: from d01relay05.pok.ibm.com (d01relay05.pok.ibm.com [9.56.227.237])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id F04326E8020
	for <linux-scsi@vger.kernel.org>; Thu, 28 Feb 2013 14:00:20 -0500 (EST)
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay05.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id r1SJ0Md3343290
	for <linux-scsi@vger.kernel.org>; Thu, 28 Feb 2013 14:00:22 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id r1SIxbhd014937
	for <linux-scsi@vger.kernel.org>; Thu, 28 Feb 2013 15:59:37 -0300
In-Reply-To: <20130227184347.437115470@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: wenxiong@linux.vnet.ibm.com
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, klebers@linux.vnet.ibm.com

Acked-by: Brian King <brking@linux.vnet.ibm.com>


-- 
Brian King
Power Linux I/O
IBM Linux Technology Center


