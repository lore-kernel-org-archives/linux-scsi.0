From: Brian King <brking@us.ibm.com>
Subject: Re: sym2 probs in bk-scsi tree
Date: Thu, 08 Apr 2004 10:16:03 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40756CB3.5010902@us.ibm.com>
References: <20040407231820.66dd76cd.akpm@osdl.org> <20040408145700.GB18329@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.105]:64147 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S261802AbUDHPQZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Apr 2004 11:16:25 -0400
In-Reply-To: <20040408145700.GB18329@parcelfarce.linux.theplanet.co.uk>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@debian.org>
Cc: Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org

Matthew Wilcox wrote:
> On Wed, Apr 07, 2004 at 11:18:20PM -0700, Andrew Morton wrote:
> 
>>This is on the power4 machine, which has previously worked quite happily.
>>
>>During boot the system spends maybe one minute dicking with the SCSI
>>controller and emitting scary new reset and abort messages.
> 
> 
> They certainly are scary.  What is device 15 on this scsi bus?  This
> looks like domain validation being applied to a device that can't do it
> to me.  Did I get that right, James?

Looks like a SES to me. Would it make sense to not log errors during 
domain validation?

-Brian


