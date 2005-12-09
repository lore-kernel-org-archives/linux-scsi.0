From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: Ang: Re: [Stgt-devel] Re: [Iscsitarget-devel] stgt a new version
 of iscsi target?
Date: Fri, 09 Dec 2005 16:31:50 -0600
Message-ID: <439A05D6.9090600@cs.wisc.edu>
References: <OF6932015B.01CF53D9-ONC12570D0.00462028@capvert.ins> <43972C2D.9060500@cs.wisc.edu> <43987F75.2000301@vlnb.net> <4398814F.7000106@cs.wisc.edu> <4399A2FF.6010307@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:17902 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S932477AbVLIWdQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Dec 2005 17:33:16 -0500
In-Reply-To: <4399A2FF.6010307@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: johan@capvert.se, iscsitarget-devel@lists.sourceforge.net, mingz@ele.uri.edu, stgt <stgt-devel@lists.berlios.de>, Robert Whitehead <WRWHITEHEAD@novell.com>, scst-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@infradead.org>

Vladislav Bolkhovitin wrote:
>>
>> Yes, I agree, I was not talking about functionality. I was only 
>> talking about how we interface with the initiator driver. My mistake. 
>> So we add a qla_tgt function callback struct (but we do it for each ha 
>> rather than global) so the initiator can call back into the target 
>> driver, so I am basically resusing that code.
> 
> 
> OK, if you reuse scst code, I hope you won't forget to insert somewhere 
> reference to its original authors :-)
> 

yes of course, when approporate I kept your copyrights even.

