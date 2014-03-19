From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH RESEND 4/7] ipr: Get rid of superfluous call to pci_disbale_msi/msix()
Date: Wed, 19 Mar 2014 15:26:17 -0500
Message-ID: <5329FD69.8060100@linux.vnet.ibm.com>
References: <20140312210845.384489953@vmlinux.vnet.ibm.com> <20140312210906.288887472@vmlinux.vnet.ibm.com> <1395258906.2185.43.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:36707 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754455AbaCSU0X (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Mar 2014 16:26:23 -0400
Received: from /spool/local
	by e33.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Wed, 19 Mar 2014 14:26:23 -0600
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id 8D67519D8036
	for <linux-scsi@vger.kernel.org>; Wed, 19 Mar 2014 14:26:16 -0600 (MDT)
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by b03cxnp08025.gho.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id s2JKQJIj55836778
	for <linux-scsi@vger.kernel.org>; Wed, 19 Mar 2014 21:26:19 +0100
Received: from d03av02.boulder.ibm.com (localhost [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id s2JKQJKi031339
	for <linux-scsi@vger.kernel.org>; Wed, 19 Mar 2014 14:26:19 -0600
In-Reply-To: <1395258906.2185.43.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Wendy Xiong <wenxiong@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Alexander Gordeev <agordeev@redhat.com>, Brian King <brking@linux.vnet.ibm.com>

On 03/19/2014 02:55 PM, James Bottomley wrote:
> On Wed, 2014-03-12 at 16:08 -0500, wenxiong@vmlinux.vnet.ibm.com wrote:
>> From: Alexander Gordeev <agordeev@redhat.com>
>>
>> There is no need to call pci_disable_msi() or pci_disable_msix()
>> in case the call to pci_enable_msi() or pci_enable_msix() failed.
>>
>> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
>> Acked-by: Brian King <brking@linux.vnet.ibm.com>
>> ---
> 
> This needs a Signed-off-by: from you as well, since you transmitted the
> patch to me.  I assume it was just omitted in error and have added it in
> the git repository.

Correcting Wendy's email address...

-Brian

-- 
Brian King
Power Linux I/O
IBM Linux Technology Center


