From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/2] ipr: Inhibit underlength data check for AFDASD in
 raw mode.
Date: Thu, 20 Aug 2015 15:27:51 -0500
Message-ID: <55D63847.7000005@linux.vnet.ibm.com>
References: <1439995626-16202-1-git-send-email-krisman@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:47699 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955AbbHTU1z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Aug 2015 16:27:55 -0400
Received: from /spool/local
	by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Thu, 20 Aug 2015 14:27:54 -0600
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
	by d03dlp01.boulder.ibm.com (Postfix) with ESMTP id 699DC1FF002D
	for <linux-scsi@vger.kernel.org>; Thu, 20 Aug 2015 14:19:02 -0600 (MDT)
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t7KKQtIa42860674
	for <linux-scsi@vger.kernel.org>; Thu, 20 Aug 2015 13:26:55 -0700
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t7KKRqAj000681
	for <linux-scsi@vger.kernel.org>; Thu, 20 Aug 2015 14:27:52 -0600
In-Reply-To: <1439995626-16202-1-git-send-email-krisman@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org

On 08/19/2015 09:47 AM, Gabriel Krisman Bertazi wrote:
> Disable underlength error verification based on count of bytes actually
> transferred for AF DASD devices when SIS pipe mode is enabled.
> 
> This avoids unexpected underlength errors when issuing some commands in
> raw mode.
> 
> Signed-off-by: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>
> ---

Looks good. Thanks!

Acked-by: Brian King <brking@linux.vnet.ibm.com>

-- 
Brian King
Power Linux I/O
IBM Linux Technology Center


