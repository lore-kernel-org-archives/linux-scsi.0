From: Ke Wei <kewei@marvell.com>
Subject: Re: [PATCH 1/8] mvsas: fill in error info record and phy mode6	bits.
Date: Thu, 27 Mar 2008 15:21:25 +0800
Message-ID: <47EB4AF5.1070500@marvell.com>
References: <47E39568.60407@marvell.com> <1206565072.3019.39.camel@localhost.localdomain>
Reply-To: kewei@marvell.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host2.marvell.com ([65.219.4.2]:45997 "EHLO maili.marvell.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754797AbYC0HVe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Mar 2008 03:21:34 -0400
In-Reply-To: <1206565072.3019.39.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, jeff@garzik.org, jacky@marvell.com, qzhao@marvell.com, qswang@marvell.com

James Bottomley wrote:
> On Fri, 2008-03-21 at 19:00 +0800, Ke Wei wrote:
>> and remove some unused members from struct.
> 
> This patch (and the following ones) look great.  I'm afraid I can't
> apply them, though ... it looks like your mail tool has stripped some
> leading spaces:
> 
>> @@ -37,11 +37,13 @@
>> #include <linux/dma-mapping.h>
>> #include <linux/ctype.h>
>> #include <scsi/libsas.h>
>> +#include <scsi/scsi_tcq.h>
>> +#include <scsi/sas_ata.h>
>> #include <asm/io.h>
> 
> And also added line breaks:
> 
>> +    PHY_MODE6_MUCNT_EN    = (1U << 24),    /* u Count Enable */
>> +    PHY_MODE6_SEL_MUCNT_LEN    = (1U << 22),    /* Training Length
>> Select */
>> +    PHY_MODE6_SELMUPI    = (1U << 20),    /* Phase Multi Select (init) */
> 
> If you need to add the patches as an attachment to get them through your
> mailer undamaged, that's fine ... the tools we have will cope with that.
> 
> Thanks,
> 
> James
> 
> 

Hello James:
	I resended mvsas patch set to community. Thank you for your help. I am moving my email client from Outlook to Thunderbird. So sometimes I need to try some configuration. 
	I have already past mvsas driver testing. By far, look well. If you have any suggestions to help me, pls let me know.


Best regards.
Ke

