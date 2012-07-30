From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [patch 2/2] [SCSI] ipr: remove an unneeded check
Date: Mon, 30 Jul 2012 07:34:05 -0500
Message-ID: <50167F3D.801@linux.vnet.ibm.com>
References: <20120730081822.GF15702@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e37.co.us.ibm.com ([32.97.110.158]:38312 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753659Ab2G3MeS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Jul 2012 08:34:18 -0400
Received: from /spool/local
	by e37.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Mon, 30 Jul 2012 06:34:17 -0600
In-Reply-To: <20120730081822.GF15702@elgon.mountain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Brian King <brking@us.ibm.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org

On 07/30/2012 03:18 AM, Dan Carpenter wrote:
> "rc" is always zero here, so there is no need to check.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Thanks!

Acked-by: Brian King <brking@linux.vnet.ibm.com>


-- 
Brian King
Power Linux I/O
IBM Linux Technology Center




