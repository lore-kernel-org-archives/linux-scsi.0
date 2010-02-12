From: Giridhar Malavali <giridhar.malavali@qlogic.com>
Subject: Re: [stable] [PATCH 0/1] qla2xxx: fix for 2.6.33-rcX
Date: Fri, 12 Feb 2010 12:37:35 -0800
Message-ID: <AF85ECFF-E4F4-494E-A974-D8D27EF598E1@qlogic.com>
References: <1265168913-353-1-git-send-email-giridhar.malavali@qlogic.com>
 <20100212202640.GA21801@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:37825 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382Ab0BLUhi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Feb 2010 15:37:38 -0500
In-Reply-To: <20100212202640.GA21801@kroah.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "stable@kernel.org" <stable@kernel.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Greg,

Sure. Will send the patch. 

Thanks,
Giridhar Malavali

On Feb 12, 2010, at 12:26 PM, Greg KH wrote:

> On Tue, Feb 02, 2010 at 07:48:32PM -0800, giridhar.malavali@qlogic.com wrote:
>> From: Giridhar Malavali <giridhar.malavali@qlogic.com>
>> 
>> James,
>> 
>> Can you please apply this patch. This is a critical fix which can cause
>> panic issues (found on PPC). This needs to be back ported to stable kernel.
> 
> This patch is now in Linus's tree, yet it does not apply to the
> 2.6.32-stable kernel.  Can you please send a version that does to the
> stable@kernel.org address so that I can apply it?
> 
> thanks,
> 
> greg k-h

