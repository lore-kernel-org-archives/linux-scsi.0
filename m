From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: I request inclusion of SAS Transport Layer and AIC-94xx into
 the kernel
Date: Thu, 29 Sep 2005 19:15:35 +0200
Message-ID: <433C2137.1040108@s5r6.in-berlin.de>
References: <43384E28.8030207@adaptec.com> <4339BFE9.1060604@pobox.com>	 <4339CCD6.5010409@adaptec.com> <4339F9A8.2030709@pobox.com>	 <433AFEB2.7090003@adaptec.com> <433B0457.7020509@pobox.com>	 <433B14E1.6080201@adaptec.com> <433B217F.4060509@pobox.com>	 <20050929040403.GE18716@alpha.home.local> <1127979848.2918.7.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:1747 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S932268AbVI2RRF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Sep 2005 13:17:05 -0400
In-Reply-To: <1127979848.2918.7.camel@laptopd505.fenrus.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Arjan van de Ven <arjan@infradead.org>, Willy Tarreau <willy@w.ods.org>, Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Luben Tuikov <luben_tuikov@adaptec.com>, Jeff Garzik <jgarzik@pobox.com>

Arjan van de Ven wrote:
> On Thu, 2005-09-29 at 06:04 +0200, Willy Tarreau wrote:
>>On Wed, Sep 28, 2005 at 07:04:31PM -0400, Jeff Garzik wrote:
>>
>>>Linux is about getting things done, not being religious about 
>>>specifications.  You are way too focused on the SCSI specs, and missing 
>>>the path we need to take to achieve additional flexibility.

AFAIU, demands to get our concepts closer to SAM concepts are actually 
motivated by this: To achieve additional flexibility. (In particular, to 
ease integration of the various transports.)

>>>With Linux, it's all about evolution and the path we take.
>>
>>Hmmm... I'm fine with "not being religious about specs", but I hope we
>>try to respect them as much as possible
> 
> a spec describes how the hw works... how we do the sw piece is up to
> us ;)

We implement drivers of initiators. (Well, targets too.) The specs 
describe _what_ initiators do. Thereby they partly describe _how_ 
drivers of initiators (our sw pieces) work.

> (I know the scsi stuff also provides sort of a reference "here is how
> you can do it in sw" but I see that more as you "you need this
> functionality" not "you need this exact architecture in your software")

This is correct. The SAM is what it is --- the SCSI-3 Architecture 
Model, not the architecture model of Linux' SCSI stack.

However it is very desirable to reflect layers and concepts of the SAM 
in our stack. One class of reasons is maintainability. No person is able 
to understand the stack; nor is a person able to consume and understand 
all or even half of the SCSI specs. No person is able to construct a 
mapping between the whole stack and the whole SCSI-3 Architecture Model 
(in his mind or with pencil and paper...). Therefore there have to be 
_components_ of the stack's architecture model which map 1:1 to 
_components_ of the SCSI-3 Architecture Model.

Fortunately, SAM layers and concepts are already there in the stack, 
although incomplete and incoherent. It will always be disputable _how_ 
complete and coherent our software should be in this respect. However it 
is out of a question that our software's architecture model might 
arbitrarily differ from the SAM.
-- 
Stefan Richter
-=====-=-=-= =--= ===-=
http://arcgraph.de/sr/
