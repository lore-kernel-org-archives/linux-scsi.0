From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 1/2] scsi: lpfc: Use kzalloc instead of kmalloc
Date: Sat, 24 Oct 2015 22:25:52 -0500
Message-ID: <BF724B49-BF78-472D-B117-87E47780FDCC@linux.vnet.ibm.com>
References: <1445670416-3705-1-git-send-email-punitvara@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:47137 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752581AbbJYDZ5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 24 Oct 2015 23:25:57 -0400
Received: from localhost
	by e33.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Sat, 24 Oct 2015 21:25:56 -0600
In-Reply-To: <1445670416-3705-1-git-send-email-punitvara@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Punit Vara <punitvara@gmail.com>
Cc: JBottomley@odin.com, don.brace@pmcs.com, storagedev@pmcs.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

> On Oct 24, 2015, at 2:06 AM, Punit Vara <punitvara@gmail.com> wrote:
> 
> This patch is to the lpfc_els.c which resolves following warning
> reported by coccicheck:
> 
> WARNING: kzalloc should be used for rdp_context, instead of
> kmalloc/memset
> 
> Signed-off-by: Punit Vara <punitvara@gmail.com>

Reviewed-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>

