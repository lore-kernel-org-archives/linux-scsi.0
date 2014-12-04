From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH RESEND 4/5] ipr: Set scsi_level correctly for disk	arrays
Date: Thu, 04 Dec 2014 10:10:49 -0600
Message-ID: <54808789.50403@linux.vnet.ibm.com>
References: <201412021847.sB2IlkT5007118@d03av01.boulder.ibm.com> <20141204092539.GA24151@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:35004 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932428AbaLDQKy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Dec 2014 11:10:54 -0500
Received: from /spool/local
	by e32.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Thu, 4 Dec 2014 09:10:54 -0700
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id 0484019D8041
	for <linux-scsi@vger.kernel.org>; Thu,  4 Dec 2014 08:59:32 -0700 (MST)
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id sB4GBIUW14352400
	for <linux-scsi@vger.kernel.org>; Thu, 4 Dec 2014 09:11:18 -0700
Received: from d03av01.boulder.ibm.com (localhost [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id sB4GAoOP030184
	for <linux-scsi@vger.kernel.org>; Thu, 4 Dec 2014 09:10:51 -0700
In-Reply-To: <20141204092539.GA24151@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, wenxiong@linux.vnet.ibm.com, anton@samba.org

On 12/04/2014 03:25 AM, Christoph Hellwig wrote:
> Do you want me to apply this patch ASAP while waiting for the kexec ACK?

Both patches 1 and 4 can be pulled in while we wait for Eric's ack.

Thanks,

Brian

-- 
Brian King
Power Linux I/O
IBM Linux Technology Center


