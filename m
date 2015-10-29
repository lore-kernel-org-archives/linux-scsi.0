From: Manoj Kumar <manoj@linux.vnet.ibm.com>
Subject: Re: [PATCH 1 03/25] hpsa: check for null arguments to dev_printk
Date: Thu, 29 Oct 2015 09:41:36 -0500
Message-ID: <56323020.6000909@linux.vnet.ibm.com>
References: <20151028215206.5323.84194.stgit@brunhilda>
 <20151028220447.5323.79638.stgit@brunhilda>
Reply-To: manoj@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:43495 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757067AbbJ2OlS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Oct 2015 10:41:18 -0400
Received: from localhost
	by e36.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <manoj@linux.vnet.ibm.com>;
	Thu, 29 Oct 2015 08:41:17 -0600
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id 98CD919D8040
	for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2015 08:29:23 -0600 (MDT)
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t9TEfD0g8388926
	for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2015 07:41:14 -0700
Received: from d03av03.boulder.ibm.com (localhost [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t9TEfCrD006140
	for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2015 08:41:13 -0600
In-Reply-To: <20151028220447.5323.79638.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org


On 10/28/2015 5:04 PM, Don Brace wrote:
> Check for NULLs.
> -	int devtype;
> +	unsigned int devtype;

Don:

Unrelated to the NULL argument check. Would have been preferable in a
distinct patch.

Reviewed-by: Manoj Kumar <manoj@linux.vnet.ibm.com>

---
Manoj Kumar


