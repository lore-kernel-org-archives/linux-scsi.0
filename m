From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH 4/7] mptfusion: zero kernel-space source of copy_to_user
Date: Fri, 6 Jun 2014 11:31:04 +0300
Message-ID: <20140606083104.GA5015@mwanda>
References: <1401900589-19672-1-git-send-email-joe.lawrence@stratus.com>
 <1401900589-19672-5-git-send-email-joe.lawrence@stratus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:27588 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390AbaFFIbo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Jun 2014 04:31:44 -0400
Content-Disposition: inline
In-Reply-To: <1401900589-19672-5-git-send-email-joe.lawrence@stratus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Lawrence <joe.lawrence@stratus.com>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Sreekanth Reddy <Sreekanth.Reddy@lsi.com>

On Wed, Jun 04, 2014 at 12:49:46PM -0400, Joe Lawrence wrote:
> Fixes the following smatch warning:
> 
>   drivers/message/fusion/mptctl.c:1369 mptctl_getiocinfo() warn:
>     possible info leak 'karg'
> 

This is a false positive.  I will push a fix for this in Smatch next
week.

regards,
dan carpenter

