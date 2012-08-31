From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/1] ipr: add new CCIN definition for new adapter support
Date: Fri, 31 Aug 2012 09:27:47 -0500
Message-ID: <5040C9E3.9010401@linux.vnet.ibm.com>
References: <20120727234201.998355188@linux.vnet.ibm.com> <20120727234301.278342824@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:38431 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753873Ab2HaOa4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 31 Aug 2012 10:30:56 -0400
Received: from /spool/local
	by e1.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Fri, 31 Aug 2012 10:30:54 -0400
Received: from d01relay05.pok.ibm.com (d01relay05.pok.ibm.com [9.56.227.237])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id DA0CC6E803C
	for <linux-scsi@vger.kernel.org>; Fri, 31 Aug 2012 10:27:49 -0400 (EDT)
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay05.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q7VERnvZ155144
	for <linux-scsi@vger.kernel.org>; Fri, 31 Aug 2012 10:27:49 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q7VERmvI010262
	for <linux-scsi@vger.kernel.org>; Fri, 31 Aug 2012 11:27:49 -0300
In-Reply-To: <20120727234301.278342824@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: wenxiong@linux.vnet.ibm.com
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

On 07/27/2012 06:42 PM, wenxiong@linux.vnet.ibm.com wrote:
> Add the appropriate definitions and table entries for new adapter support.
> 
> Signed-off-by: Wen Xiong<wenxiong@linux.vnet.ibm.com>
> ---
>  drivers/scsi/ipr.c |   10 ++++++++++
>  drivers/scsi/ipr.h |    5 +++++
>  2 files changed, 15 insertions(+)

Acked-by: Brian King <brking@linux.vnet.ibm.com>

-- 
Brian King
Power Linux I/O
IBM Linux Technology Center


