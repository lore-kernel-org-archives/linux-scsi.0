From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/1] ipr: possible irq lock inversion dependency detected
Date: Fri, 31 May 2013 07:29:06 -0500
Message-ID: <51A89792.1010500@linux.vnet.ibm.com>
References: <20130524145912.801776828@linux.vnet.ibm.com> <20130524145946.307147926@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:41495 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754596Ab3EaM3M (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 31 May 2013 08:29:12 -0400
Received: from /spool/local
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Fri, 31 May 2013 06:29:12 -0600
Received: from d01relay03.pok.ibm.com (d01relay03.pok.ibm.com [9.56.227.235])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id 77C036E803A
	for <linux-scsi@vger.kernel.org>; Fri, 31 May 2013 08:29:05 -0400 (EDT)
Received: from d01av05.pok.ibm.com (d01av05.pok.ibm.com [9.56.224.195])
	by d01relay03.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id r4VCT8Ma246048
	for <linux-scsi@vger.kernel.org>; Fri, 31 May 2013 08:29:08 -0400
Received: from d01av05.pok.ibm.com (loopback [127.0.0.1])
	by d01av05.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id r4VCT8b0018019
	for <linux-scsi@vger.kernel.org>; Fri, 31 May 2013 08:29:08 -0400
In-Reply-To: <20130524145946.307147926@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: wenxiong@linux.vnet.ibm.com
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

On 05/24/2013 09:59 AM, wenxiong@linux.vnet.ibm.com wrote:
> When enable lockdep, seeing "possible irq lock inversion dependency detected"
> error. This patch fixes the issue.
> 
> Signed-off-by: Wen Xiong <wenxiong@linux.vnet.ibm.com>

Acked-by: Brian King <brking@linux.vnet.ibm.com>

-- 
Brian King
Power Linux I/O
IBM Linux Technology Center


