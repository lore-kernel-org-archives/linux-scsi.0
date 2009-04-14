From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: [Scst-devel] [ANNOUNCE]: Comparison of features sets between
 	different SCSI targets (SCST, STGT, IET, LIO)
Date: Tue, 14 Apr 2009 13:07:31 +0200
Message-ID: <49E46E73.8020703@wpkg.org>
References: <49D7AD54.4060408@vlnb.net> <49D7B122.50103@wpkg.org> <e2e108260904050429lcd1870ag6656f36a170ccab3@mail.gmail.com> <49D9D9A0.40106@wpkg.org> <49DA33EF.3020700@vlnb.net> <49DA49AA.1060106@wpkg.org> <49DE4243.5060004@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx03.syneticon.net ([78.111.66.105]:53084 "EHLO
	mx03.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540AbZDNLHi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Apr 2009 07:07:38 -0400
In-Reply-To: <49DE4243.5060004@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: Bart Van Assche <bart.vanassche@gmail.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, iscsitarget-devel@lists.sourceforge.net, James Bottomley <James.Bottomley@hansenpartnership.com>, scst-devel <scst-devel@lists.sourceforge.net>, stgt@vger.kernel.org

Vladislav Bolkhovitin schrieb:

>> Could anyone recheck if it's the same on some other system?
>>
>>> Which IO scheduler on the target did you use? I guess, deadline? If 
>>> so, you should try with CFQ as well.
>>
>> I used CFQ.
> 
> You didn't apply io_context-XXX.patch, correct? With it you should see a 
>  noticeable increase, like in http://scst.sourceforge.net/vl_res.txt.

I didn't apply this one.

I used 2.6.26.x kernel and io_context-XXX.patch was for 2.6.27, 2.6.28 
and 2.6.29 only; 2.6.27 fails to apply to 2.6.26.8 kernel (perhaps in a 
trivial way, I didn't check).


-- 
Tomasz Chmielewski
http://wpkg.org
