From: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/4] ipr: Fix locking for unit attention handling
Date: Tue, 16 Jun 2015 11:40:29 -0300
Message-ID: <87bngfogwy.fsf@linux.vnet.ibm.com>
References: <201506120145.t5C1jFQW016709@d01av04.pok.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e24smtp02.br.ibm.com ([32.104.18.86]:55297 "EHLO
	e24smtp02.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054AbbFPOki (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Jun 2015 10:40:38 -0400
Received: from /spool/local
	by e24smtp02.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <krisman@linux.vnet.ibm.com>;
	Tue, 16 Jun 2015 11:40:33 -0300
In-Reply-To: <201506120145.t5C1jFQW016709@d01av04.pok.ibm.com> (Brian King's
	message of "Thu, 11 Jun 2015 20:45:15 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, wenxiong@linux.vnet.ibm.com, gbertazi@linux.vnet.ibm.com, stable@vger.kernel.org

Brian King <brking@linux.vnet.ibm.com> writes:

> Make sure we have the host lock held when calling scsi_report_bus_reset. Fixes
> a crash seen as the __devices list in the scsi host was changing as we were
> iterating through it.

Brian,

The patch series look good to me as a whole, thanks for doing that.
Please add the tag:

Reviewed-by: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>

Thanks,

-- 
Gabriel Krisman Bertazi

