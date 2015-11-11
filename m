From: Manoj Kumar <manoj@linux.vnet.ibm.com>
Subject: Re: [PATCH RESEND] scsi: Set sg_tablesize to 1, for LLDDs that set
 SG_NONE
Date: Wed, 11 Nov 2015 09:27:00 -0600
Message-ID: <56435E44.7050609@linux.vnet.ibm.com>
References: <1447195520-27307-1-git-send-email-manoj@linux.vnet.ibm.com>
 <5642EE3A.50308@suse.de>
Reply-To: manoj@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e19.ny.us.ibm.com ([129.33.205.209]:59797 "EHLO
	e19.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885AbbKKP0Z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Nov 2015 10:26:25 -0500
Received: from localhost
	by e19.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <manoj@linux.vnet.ibm.com>;
	Wed, 11 Nov 2015 10:26:24 -0500
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id 8E150C90046
	for <linux-scsi@vger.kernel.org>; Wed, 11 Nov 2015 10:14:31 -0500 (EST)
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id tABFQLnm64684140
	for <linux-scsi@vger.kernel.org>; Wed, 11 Nov 2015 15:26:21 GMT
Received: from d01av03.pok.ibm.com (localhost [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id tABFQKRb007834
	for <linux-scsi@vger.kernel.org>; Wed, 11 Nov 2015 10:26:20 -0500
In-Reply-To: <5642EE3A.50308@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org
Cc: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, Youngjae Lee <leeyo@linux.vnet.ibm.com>

Hannes:

A very valid point. Thanks for your suggestion.
Will look at resolving the issue in blk-mq.

Regards,
- Manoj

On 11/11/2015 1:28 AM, Hannes Reinecke wrote:
> Shouldn't we rather fixup blk-mq to properly support SG_NONE?
> Silently converting SG_NONE (=0) to 1 has a fair chance of breaking
> non-mq enabled setups, which happily work with SG_NONE currently.
>
> Cheers,
>
> Hannes
>

