From: Stefan Smietanowski <stesmi@stesmi.com>
Subject: Re: Binary-only firmware covered by the GPL?
Date: Fri, 26 Mar 2004 15:19:38 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40643BFA.1000302@stesmi.com>
References: <20040325225423.GT9248@cheney.cx> <MDEHLPKNGKAHNMBLJOLKCEEOLEAA.davids@webmaster.com> <20040326131629.GB26910@zombie.inka.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 1-2-2-1a.has.sth.bostream.se ([82.182.130.86]:13480 "EHLO
	K-7.stesmi.com") by vger.kernel.org with ESMTP id S262157AbUCZOTq
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Mar 2004 09:19:46 -0500
In-Reply-To: <20040326131629.GB26910@zombie.inka.de>
List-Id: linux-scsi@vger.kernel.org
To: Eduard Bloch <edi@gmx.de>
Cc: David Schwartz <davids@webmaster.com>, debian-devel@lists.debian.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Eduard Bloch wrote:

> #include <hallo.h>
> * David Schwartz [Thu, Mar 25 2004, 04:41:23PM]:
> 
> 
>>>IMHO code that can be compiled would probably be the preferred form
>>>of the work.
>>
>>	You are seriously arguing that the obfuscated binary of the firmware is the
>>preferred form of the firmware for the purpose of making modifications to
>>it?!
> 
> 
> Yes, the driver authors PREFERS to make the changes on the C source
> code, he never has to modify the firmware. Exactly what the GPL
> requests, where is your problem?

But the firmware didn't appear out of thin air - someone wrote it
somehow. If that's using a hex editor or inside the C code doesn't
matter, but most likely they used some other language like either
C or assembly (no, not all firmware is written using assembly), and
there are cases where some are in fact written using a hex editor but
I can't remember any that has been for the last 30 or so years but
I'm sure there has been cases where there hasn't been a working
assembler.

// Stefan
