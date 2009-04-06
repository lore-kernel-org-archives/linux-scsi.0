From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: [Scst-devel] [ANNOUNCE]: Comparison of features sets between
 different SCSI targets (SCST, STGT, IET, LIO)
Date: Mon, 06 Apr 2009 11:44:58 +0200
Message-ID: <49D9CF1A.3090702@wpkg.org>
References: <49D7AD54.4060408@vlnb.net> <49D7B122.50103@wpkg.org> <49D7B320.4000506@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx03.syneticon.net ([78.111.66.105]:47153 "EHLO
	mx03.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755969AbZDFJpF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Apr 2009 05:45:05 -0400
In-Reply-To: <49D7B320.4000506@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: linux-scsi@vger.kernel.org, iscsitarget-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, stgt@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, scst-devel <scst-devel@lists.sourceforge.net>

Vladislav Bolkhovitin schrieb:
> Tomasz Chmielewski, on 04/04/2009 11:12 PM wrote:
>> Vladislav Bolkhovitin schrieb:
>>> Hi All,
>>>
>>> I set up http://scst.sourceforge.net/comparison.html page, which 
>>> compares features of existing SCSI target subsystems for Linux. The 
>>> comparison includes SCST, STGT, IET and LIO.
>>>
>>> I might be not fully correct somewhere, so, if you don't agree with 
>>> me about some item(s) in the comparison table, please let me know and 
>>> I will fix that.
>>
>> Performance is a bit debatable.
> 
> The result "in average" was listed in the comparison. Of course, one 
> target can be better somewhere, another one somewhere else. That a 
> nature of storage: it's pretty hard to optimize for all at once.

True.


> BTW, if I remember correctly your logs, you didn't apply all the SCST 
> kernel patches on your kernel. Then your results aren't much applicable 
> to this comparison, because it assumes all SCST kernel patches applied.

I made three tests:
- STGT (with standard Debian Lenny kernel)
- SCST with default build options (i.e. no "make debug2perf"), no kernel 
patches (standard Debian Lenny kernel)
- SCST + "make debug2perf", with kernel patches (Debian Lenny .config + 
SCST patches and proper option enabled)

I'll post the results shortly.


-- 
Tomasz Chmielewski
http://wpkg.org

