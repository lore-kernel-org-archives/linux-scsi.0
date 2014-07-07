From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH] ibmvfc: fix little endian issues
Date: Mon, 07 Jul 2014 18:21:03 -0500
Message-ID: <53BB2B5F.6080206@linux.vnet.ibm.com>
References: <1403827435-29522-1-git-send-email-tyreld@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:33314 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554AbaGGXV5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jul 2014 19:21:57 -0400
Received: from /spool/local
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Mon, 7 Jul 2014 17:21:57 -0600
In-Reply-To: <1403827435-29522-1-git-send-email-tyreld@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, jbottomley@parallels.com, linuxppc-dev@ozlabs.org

On 06/26/2014 07:03 PM, Tyrel Datwyler wrote:
> Added big endian annotations to relevant data structure fields, and necessary
> byte swappings to support little endian builds.

Acked-by: Brian King <brking@linux.vnet.ibm.com>

Thanks,

Brian

-- 
Brian King
Power Linux I/O
IBM Linux Technology Center


