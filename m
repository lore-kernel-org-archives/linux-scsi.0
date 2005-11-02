From: Martin Devera <devik@cdi.cz>
Subject: Re: [PATCH]: Fusion-MPT slowness workaround
Date: Wed, 02 Nov 2005 11:18:09 +0100
Message-ID: <43689261.2070802@cdi.cz>
References: <200511012227.jA1MRvg01220@unix-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from www1.cdi.cz ([194.213.194.49]:51638 "EHLO www1.cdi.cz")
	by vger.kernel.org with ESMTP id S1751538AbVKBKS0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Nov 2005 05:18:26 -0500
In-Reply-To: <200511012227.jA1MRvg01220@unix-os.sc.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Chen, Kenneth W" <kenneth.w.chen@intel.com>
Cc: "'Moore, Eric Dean'" <Eric.Moore@lsil.com>, bstroesser@fujitsu-siemens.com, rupert@aquabolt.com, linux-scsi@vger.kernel.org

Chen, Kenneth W wrote:
> Moore, Eric Dean wrote on Tuesday, November 01, 2005 2:09 PM
> 
>>On Tuesday, November 01, 2005 2:39 PM, Chen, Kenneth W wrote:
>>
>>>>I've added spin-lock to control domain validation, and 
>>>>alternate controller bringup which are occuring at the same time,
>>>>and causing dv to fail.  Thanks to Kenneth Chen and Bodo Stroesser.
>>>
>>>With the patch, Kernel hung at boot (2.6.14 is used).
>>>
>>
>>Try this patch instead.  Use it over 2.6.14, not over the
>>previous post.
>>
>>This patch is one that Bodo provided.  Let me know the results.
> 
> Looks OK, kernel boots and DV appears to be running correctly.

Not here. Both performance*patch patches boot ok here but I/O remains
slow in both cases. I double checked against mixing patches but only
disabling DV works here.
Tested with 2.6.14 kernel, no modules.

regards, Martin
