From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/8] V2 Add support for new IBM SAS controllers
Date: Mon, 14 Jan 2013 16:13:43 -0600
Message-ID: <50F48317.7020104@linux.vnet.ibm.com>
References: <20130111234346.012076652@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e8.ny.us.ibm.com ([32.97.182.138]:38552 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756432Ab3ANWOJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Jan 2013 17:14:09 -0500
Received: from /spool/local
	by e8.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Mon, 14 Jan 2013 17:14:07 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id A56296E803A
	for <linux-scsi@vger.kernel.org>; Mon, 14 Jan 2013 17:13:44 -0500 (EST)
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id r0EMDjAl284730
	for <linux-scsi@vger.kernel.org>; Mon, 14 Jan 2013 17:13:45 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id r0EMDijd021006
	for <linux-scsi@vger.kernel.org>; Mon, 14 Jan 2013 20:13:44 -0200
In-Reply-To: <20130111234346.012076652@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: wenxiong@linux.vnet.ibm.com
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, klebers@linux.vnet.ibm.com

On 01/11/2013 05:43 PM, wenxiong@linux.vnet.ibm.com wrote:
> This is version 2 of ipr patches to support new IBM SAS controllers. 
> In V2, we have fixed the following suggestions/warning/sparse errors:
> 
> 1.Changed simple_strtoul() to kstrtoul() in ipr_restore_iopoll_weight routine.
> 2.Removed the __dev annotations.
> 3.Fixed unlock bugs which are caused by my previous patches(reported by sparse).
> 4.BUG_ON gcc 4.7 warning.
> 5.Fixed sparse error in original ipr driver.

James,

I've pulled down the series, made sure it builds on x86 with a recent
gcc, as well as ran them through sparse and smatch. This should
address the issues previously encountered with the patch set. Additionally,
it should ensure the series is bisectable.

The only thing I noticed was that the subject line has the V2
outside of []. Would you like Wendy to resend the series to fix this
in order to make it easier to apply?

Acked-by: Brian King <brking@linux.vnet.ibm.com>

Thanks,

Brian

-- 
Brian King
Power Linux I/O
IBM Linux Technology Center


