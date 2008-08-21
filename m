From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [patch 17/18] scsi: select CRC_T10DIF only when necessary
Date: Thu, 21 Aug 2008 09:19:56 -0500
Message-ID: <1219328396.3265.4.camel@localhost.localdomain>
References: <200808202355.m7KNtaxo006233@imap1.linux-foundation.org>
	 <yq1vdxuzcum.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:36842 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750801AbYHUOUA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Aug 2008 10:20:00 -0400
In-Reply-To: <yq1vdxuzcum.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: akpm@linux-foundation.org, linux-scsi@vger.kernel.org, stefanr@s5r6.in-berlin.de

On Thu, 2008-08-21 at 10:01 -0400, Martin K. Petersen wrote:
> -	select CRC_T10DIF
> +	select CRC_T10DIF if BLK_DEV_INTEGRITY
> 
> Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

Actually, I don't think this is right at all.

This is a purely cosmetic fix and the tip of the iceberg.  If not
compiling in the integrity code matters on grounds of kernel bloat, and
I think it does, then the correct fix is to make sure none of it
compiles into SD if BLK_DEV_INTEGRITY isn't set.

James


