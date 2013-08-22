From: Jingoo Han <jg1.han@samsung.com>
Subject: Re: [PATCH 2/8] zfcp: cleanup use of obsolete strict_strto* functions
Date: Thu, 22 Aug 2013 09:08:32 +0900
Message-ID: <000e01ce9ecb$bd2a51a0$377ef4e0$%han@samsung.com>
References: <1377097531-4942-1-git-send-email-maier@linux.vnet.ibm.com>
 <1377097531-4942-3-git-send-email-maier@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:22382 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740Ab3HVAIf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Aug 2013 20:08:35 -0400
In-reply-to: <1377097531-4942-3-git-send-email-maier@linux.vnet.ibm.com>
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Steffen Maier' <maier@linux.vnet.ibm.com>, 'James Bottomley' <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, 'Martin Schwidefsky' <schwidefsky@de.ibm.com>, 'Heiko Carstens' <heiko.carstens@de.ibm.com>, 'Martin Peschke' <mpeschke@linux.vnet.ibm.com>, 'Jingoo Han' <jg1.han@samsung.com>

On Thursday, August 22, 2013 12:05 AM, Steffen Maier wrote:
> 
> From: Martin Peschke <mpeschke@linux.vnet.ibm.com>
> 
> strict_strtoul and friends are obsolete. Use kstrtoul functions
> instead.
> 
> Signed-off-by: Martin Peschke <mpeschke@linux.vnet.ibm.com>
> Cc: Jingoo Han <jg1.han@samsung.com>

Reviewed-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han

> Signed-off-by: Steffen Maier <maier@linux.vnet.ibm.com>
> ---
>  drivers/s390/scsi/zfcp_aux.c   |    4 ++--
>  drivers/s390/scsi/zfcp_sysfs.c |   12 ++++++------
>  2 files changed, 8 insertions(+), 8 deletions(-)

