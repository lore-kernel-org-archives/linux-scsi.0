From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/2] ipr: Convert to generic DMA API
Date: Wed, 29 Oct 2014 12:34:49 -0500
Message-ID: <54512539.5040501@linux.vnet.ibm.com>
References: <1413191676-1663-1-git-send-email-anton@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:53806 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934130AbaJ2Re5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Oct 2014 13:34:57 -0400
Received: from /spool/local
	by e34.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Wed, 29 Oct 2014 11:34:57 -0600
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
	by d03dlp02.boulder.ibm.com (Postfix) with ESMTP id C1D323E40044
	for <linux-scsi@vger.kernel.org>; Wed, 29 Oct 2014 11:34:53 -0600 (MDT)
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id s9THYrZc53674152
	for <linux-scsi@vger.kernel.org>; Wed, 29 Oct 2014 18:34:53 +0100
Received: from d03av01.boulder.ibm.com (localhost [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id s9THYqWZ002772
	for <linux-scsi@vger.kernel.org>; Wed, 29 Oct 2014 11:34:53 -0600
In-Reply-To: <1413191676-1663-1-git-send-email-anton@samba.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anton Blanchard <anton@samba.org>, benh@kernel.crashing.org, paulus@samba.org, mpe@ellerman.id.au, wenxiong@linux.vnet.ibm.com, scottwood@freescale.com
Cc: linuxppc-dev@lists.ozlabs.org, linux-scsi@vger.kernel.org

Acked-by: Brian King <brking@linux.vnet.ibm.com>

-- 
Brian King
Power Linux I/O
IBM Linux Technology Center


