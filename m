From: Kyle Fortin <kyle.fortin@oracle.com>
Subject: Re: [PATCH] scsi: logging_level: update bits description
Date: Tue, 10 Oct 2017 15:32:00 -0400
Message-ID: <216D3DB1-C329-4B75-8210-822FF889C344@oracle.com>
References: <7d747a9b-e0a0-0f64-f1f3-66338ec7bbea@infradead.org>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:34560 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751626AbdJJTcg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Oct 2017 15:32:36 -0400
In-Reply-To: <7d747a9b-e0a0-0f64-f1f3-66338ec7bbea@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>

Hi Randy,

On Oct 10, 2017, at 3:05 PM, Randy Dunlap <rdunlap@infradead.org> wrote:
> 
> From: Randy Dunlap <rdunlap@infradead.org>
> 
> Update the description of 'scsi_logging_level' from 8 4-bit nibbles
> to the (pre-git) reality of 10 3-bit 'nibbles'.
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> ---
> drivers/scsi/scsi_logging.h |    8 ++++----
> 1 file changed, 4 insertions(+), 4 deletions(-)
> 
> --- lnx-414-rc3.orig/drivers/scsi/scsi_logging.h
> +++ lnx-414-rc3/drivers/scsi/scsi_logging.h
> @@ -3,10 +3,10 @@
> 
> 
> /*
> - * This defines the scsi logging feature.  It is a means by which the user
> - * can select how much information they get about various goings on, and it
> - * can be really useful for fault tracing.  The logging word is divided into
> - * 8 nibbles, each of which describes a loglevel.  The division of things is
> + * This defines the scsi logging feature.  It is a means by which the user can
> + * select how much information they get about various goings on, and it can be
> + * really useful for fault tracing.  The logging word is divided into 10 3-bit
> + * 'nibbles', each of which describes a loglevel.  The division of things is

I think ‘bitfields' is more appropriate than ‘nibbles’ (a 4-bit construct in compute).

>  * somewhat arbitrary, and the division of the word could be changed if it
>  * were really needed for any reason.  The numbers below are the only place
>  * where these are specified.  For a first go-around, 3 bits is more than

Reviewed-by: Kyle Fortin <kyle.fortin@oracle.com>
