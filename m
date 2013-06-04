From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/1] ipr: IOA Status Code(IOASC) update
Date: Tue, 04 Jun 2013 17:29:02 -0500
Message-ID: <51AE6A2E.1040407@linux.vnet.ibm.com>
References: <20130604031956.483531143@linux.vnet.ibm.com> <20130604032041.917550613@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e7.ny.us.ibm.com ([32.97.182.137]:49266 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750811Ab3FDW3J (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Jun 2013 18:29:09 -0400
Received: from /spool/local
	by e7.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Tue, 4 Jun 2013 18:29:08 -0400
Received: from d01relay05.pok.ibm.com (d01relay05.pok.ibm.com [9.56.227.237])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id DE54C38C8047
	for <linux-scsi@vger.kernel.org>; Tue,  4 Jun 2013 18:29:05 -0400 (EDT)
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay05.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id r54MT61C334634
	for <linux-scsi@vger.kernel.org>; Tue, 4 Jun 2013 18:29:06 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id r54MT4IP017937
	for <linux-scsi@vger.kernel.org>; Tue, 4 Jun 2013 18:29:05 -0400
In-Reply-To: <20130604032041.917550613@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: wenxiong@linux.vnet.ibm.com
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

On 06/03/2013 10:19 PM, wenxiong@linux.vnet.ibm.com wrote:

> @@ -407,10 +419,18 @@ struct ipr_error_table_t ipr_error_table
>  	"Illegal request, command sequence error"},
>  	{0x052C8000, 1, 0,
>  	"Illegal request, dual adapter support not enabled"},
> +	{0x052C8100, 1, 0,
> +	"Illegal request, another cable connector was physically disable"},

disable should be disabled

> @@ -507,10 +537,18 @@ struct ipr_error_table_t ipr_error_table
>  	"9062: One or more disks are missing from an array"},
>  	{0x07279900, 0, IPR_DEFAULT_LOG_LEVEL,
>  	"9063: Maximum number of functional arrays has been exceeded"},
> +	{0x07279A00, 0, 0,
> +	"Data protect, other volume set problem"},
>  	{0x0B260000, 0, 0,
>  	"Aborted command, invalid descriptor"},
> +	{0x0B3F9000, 0, 0,
> +	"Target operating conditions have changed, dua adapter takeover"},

dua should be dual

Thanks,

Brian

-- 
Brian King
Power Linux I/O
IBM Linux Technology Center


