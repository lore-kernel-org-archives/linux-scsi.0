From: Bryan Henderson <hbryan@us.ibm.com>
Subject: Re: Kernel build problem
Date: Wed, 1 Sep 2004 11:50:38 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OFB18D1FAD.35B82B72-ON88256F02.0066A507-88256F02.00678655@us.ibm.com>
References: <200409011623.i81GNtSC011621@bach.leonora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.102]:13981 "EHLO e2.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S266263AbUIASuU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Sep 2004 14:50:20 -0400
In-Reply-To: <200409011623.i81GNtSC011621@bach.leonora.org>
List-Id: linux-scsi@vger.kernel.org
To: "Vladimir G. Ivanovic" <vladimir@acm.org>
Cc: "Dunn, Charles" <CDunn@empirix.com>, linux-scsi@vger.kernel.org

>>I went around and around with RH sales about this. No
>>complaints about the sales person, she really tried to get to the bottom
>>of why this is the way it is, and she even found the answer.. In talking
>>with her it was clear that in 99% of her conversations with RH engineers
>>the attitude was one of: "Debuggers produce bad fixes. Always. Debuggers
>>are evil.".. 

>To be fair, it's not really a Red Hat issue, but rather Linus's belief
>that debuggers lead to patching symptoms rather than fixing the
>underlying problem.

It's a Red Hat issue.  Linus doesn't ship Red Hat products.  The 
information in this email says that Red Hat engineers share Linus's 
belief, and suggests that their own position is what keeps debuggers out 
of Red Hat products.

It's clear that Red Hat is capable of shipping a version of Linux other 
than Linus', and that makes it equally clear that Red Hat itself doesn't 
want a debugger in its version of Linux.

It would be fair to say that if Linus believed differently, a debugger 
would probably be in Red Hat Linux products, but it wouldn't be fair to 
say this is not a Red Hat issue.  Red Hat has a decision to make just like 
SUSE has.

--
Bryan Henderson                          IBM Almaden Research Center
San Jose CA                              Filesystems
