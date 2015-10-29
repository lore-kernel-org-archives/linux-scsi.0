From: Manoj Kumar <manoj@linux.vnet.ibm.com>
Subject: Re: [PATCH 1 02/25] hpsa: remove unused hpsa_tag_discard_error_bits
Date: Thu, 29 Oct 2015 09:37:17 -0500
Message-ID: <56322F1D.9060803@linux.vnet.ibm.com>
References: <20151028215206.5323.84194.stgit@brunhilda>
 <20151028220441.5323.9715.stgit@brunhilda>
Reply-To: manoj@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:35005 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757324AbbJ2Og6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Oct 2015 10:36:58 -0400
Received: from localhost
	by e36.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <manoj@linux.vnet.ibm.com>;
	Thu, 29 Oct 2015 08:36:57 -0600
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
	by d03dlp02.boulder.ibm.com (Postfix) with ESMTP id 37A9C3E4003F
	for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2015 08:36:55 -0600 (MDT)
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t9TEash447251474
	for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2015 07:36:54 -0700
Received: from d03av03.boulder.ibm.com (localhost [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t9TEasbr018623
	for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2015 08:36:54 -0600
In-Reply-To: <20151028220441.5323.9715.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

Don: See comment below.

- Manoj Kumar

On 10/28/2015 5:04 PM, Don Brace wrote:
> This function is no longer used.
>
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> +#define HPSA_PERF_ERROR_BITS ((1 << DIRECT_LOOKUP_SHIFT) - 1)

HPSA_PERF_ERROR_BITS seems to be only used in the function that was
removed. Is there a reason to redefine this?


