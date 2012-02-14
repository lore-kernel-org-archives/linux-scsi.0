From: Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>
Subject: Re: [PATCH] ipr: fix eeh recovery for 64-bit adapters
Date: Tue, 14 Feb 2012 15:41:34 -0200
Message-ID: <4F3A9CCE.8060601@linux.vnet.ibm.com>
References: <1326749425-28778-1-git-send-email-klebers@linux.vnet.ibm.com> <4F149ED9.2000304@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e24smtp01.br.ibm.com ([32.104.18.85]:41617 "EHLO
	e24smtp01.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868Ab2BNRll (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Feb 2012 12:41:41 -0500
Received: from /spool/local
	by e24smtp01.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <klebers@linux.vnet.ibm.com>;
	Tue, 14 Feb 2012 15:41:38 -0200
Received: from d24relay02.br.ibm.com (d24relay02.br.ibm.com [9.13.184.26])
	by d24dlp01.br.ibm.com (Postfix) with ESMTP id 20806352004D
	for <linux-scsi@vger.kernel.org>; Tue, 14 Feb 2012 15:41:37 -0200 (BRST)
Received: from d24av01.br.ibm.com (d24av01.br.ibm.com [9.8.31.91])
	by d24relay02.br.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q1EHfaKY24903842
	for <linux-scsi@vger.kernel.org>; Tue, 14 Feb 2012 15:41:36 -0200
Received: from d24av01.br.ibm.com (loopback [127.0.0.1])
	by d24av01.br.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q1EFfTaI025061
	for <linux-scsi@vger.kernel.org>; Tue, 14 Feb 2012 13:41:29 -0200
In-Reply-To: <4F149ED9.2000304@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Brian King <brking@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Wayne Boyer <wayneb@linux.vnet.ibm.com>, Wendy Xiong <wenxiong@linux.vnet.ibm.com>

On 01/16/2012 08:04 PM, Brian King wrote:

> Acked-by: Brian King <brking@linux.vnet.ibm.com>
> 


Hello James,

Is this patch queued for the next merge window?


Thanks,

-- 
Kleber Sacilotto de Souza
IBM Linux Technology Center

