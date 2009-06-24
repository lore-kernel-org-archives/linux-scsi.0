From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 1/3] bnx2i remove not so useful global variable bnx2i_reg_devices
Date: Wed, 24 Jun 2009 15:00:18 -0500
Message-ID: <4A4285D2.5000705@cs.wisc.edu>
References: <1245805860.9829.50.camel@anilgv-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:51209 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751679AbZFXUAY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Jun 2009 16:00:24 -0400
In-Reply-To: <1245805860.9829.50.camel@anilgv-desktop>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anil Veerabhadrappa <anilgv@broadcom.com>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, mchan@broadcom.com

On 06/23/2009 08:11 PM, Anil Veerabhadrappa wrote:
>> From a8267738e9ca5c73ad6c0d89f17cf864bfc908c8 Mon Sep 17 00:00:00 2001
> From: Anil Veerabhadrappa<anilgv@broadcom.com>
> Date: Tue, 23 Jun 2009 13:56:29 -0700
> Subject: [PATCH]     bnx2i - remove global variable bnx2i_reg_devices
>
>      * Removed bnx2i_reg_devices as this counter is not really
>        used in a meaningful way
>
>      Cc: Mike Christie<michaelc@cs.wisc.edu>
>
> Signed-off-by: Michael Chan<mchan@broadcom.com>
> Signed-off-by: Anil Veerabhadrappa<anilgv@broadcom.com>

Thanks for finishing up this cleanup from the review.

All patches

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
