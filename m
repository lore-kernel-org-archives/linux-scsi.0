From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/2] ipr: Enable SIS pipe commands for SIS-32 devices.
Date: Thu, 20 Aug 2015 15:28:17 -0500
Message-ID: <55D63861.9000003@linux.vnet.ibm.com>
References: <1439995626-16202-1-git-send-email-krisman@linux.vnet.ibm.com> <1439995626-16202-2-git-send-email-krisman@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e38.co.us.ibm.com ([32.97.110.159]:36881 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752382AbbHTU2V (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Aug 2015 16:28:21 -0400
Received: from /spool/local
	by e38.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Thu, 20 Aug 2015 14:28:21 -0600
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id 9F38019D8041
	for <linux-scsi@vger.kernel.org>; Thu, 20 Aug 2015 14:19:14 -0600 (MDT)
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t7KKRKlO35061762
	for <linux-scsi@vger.kernel.org>; Thu, 20 Aug 2015 13:27:20 -0700
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t7KKSHB3003235
	for <linux-scsi@vger.kernel.org>; Thu, 20 Aug 2015 14:28:17 -0600
In-Reply-To: <1439995626-16202-2-git-send-email-krisman@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org

On 08/19/2015 09:47 AM, Gabriel Krisman Bertazi wrote:
> Remove unnecessary check that disabled SIS pipe commands for SIS-32
> devices.  This change was sufficient to enable raw mode and send SIS
> pipe commands for a 57B3 device.
> 
> Fixes: f8ee25d7d239 ("ipr: AF DASD raw mode implementation in ipr driver")
> Signed-off-by: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>
> ---

Thanks!

Acked-by: Brian King <brking@linux.vnet.ibm.com>

-- 
Brian King
Power Linux I/O
IBM Linux Technology Center


