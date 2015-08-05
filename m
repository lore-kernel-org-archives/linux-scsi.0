From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH v3 1/4] cxlflash: Updates to legacy I/O
Date: Wed, 05 Aug 2015 10:44:12 -0500
Message-ID: <55C22F4C.1030001@linux.vnet.ibm.com>
References: <1438576364-32896-1-git-send-email-mrochs@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e37.co.us.ibm.com ([32.97.110.158]:42863 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753572AbbHEPoW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Aug 2015 11:44:22 -0400
Received: from /spool/local
	by e37.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Wed, 5 Aug 2015 09:44:22 -0600
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
	by d03dlp02.boulder.ibm.com (Postfix) with ESMTP id 85B423E40041
	for <linux-scsi@vger.kernel.org>; Wed,  5 Aug 2015 09:44:18 -0600 (MDT)
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t75FfaPP42401894
	for <linux-scsi@vger.kernel.org>; Wed, 5 Aug 2015 08:41:36 -0700
Received: from d03av01.boulder.ibm.com (localhost [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t75FiFUm008923
	for <linux-scsi@vger.kernel.org>; Wed, 5 Aug 2015 09:44:18 -0600
In-Reply-To: <1438576364-32896-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, nab@linux-iscsi.org, wenxiong@linux.vnet.ibm.com, shane.seymour@hp.com
Cc: hch@infradead.org, mikey@neuling.org, imunsie@au1.ibm.com, dja@ozlabs.au.ibm.com, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

Hi Matt,

Can you break this up into separate patches for these separate logical bug fixes / changes?
There is too much bundled all into a single patch here from my perspective.

Thanks,

Brian

-- 
Brian King
Power Linux I/O
IBM Linux Technology Center


