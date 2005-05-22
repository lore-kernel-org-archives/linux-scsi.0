From: Derek Martin <code@pizzashack.org>
Subject: Fwd: SCSI debug info
Date: Sun, 22 May 2005 16:56:20 -0400
Message-ID: <20050522205620.GE6671@sophic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from thoth.sophic.org ([70.88.204.20]:37334 "EHLO thoth.sophic.org")
	by vger.kernel.org with ESMTP id S261740AbVEVU4V convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 22 May 2005 16:56:21 -0400
Received: from thoth.sophic.org (localhost [127.0.0.1])
	by thoth.sophic.org (8.12.8/8.12.8) with ESMTP id j4MKuLEW007088
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Sun, 22 May 2005 16:56:21 -0400
Received: (from ddm@localhost)
	by thoth.sophic.org (8.12.8/8.12.8/Submit) id j4MKuK9N007086
	for linux-scsi@vger.kernel.org; Sun, 22 May 2005 16:56:20 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi all,

I'm a system administrator at a company with a large number of
machines at remote locations.  Naturally, many of these machines
develop hardware problems, and some may be deployed with SCSI
connections that aren't so connected after all.

I'm wondering if there is any documentation which can explain how to
interpret the error messages which the kernel reports, for those of us
who are mere mortals (i.e. neither experienced Linux kernel developers
nor SCSI gods).  The messages reported are pretty much unintelligible
to those of us who didn't major in SCSI in college. :)  Actually I
pinged some people recently who have done kernel development
professionally, and the response was generally that even with the
source code in front of you, the messages still tend to be a bit
cryptic...

So any links to relevant info would be appreciated.  I'm specifically
interested in identifying messages which would help differentiate
the category of problems, e.g. disk failure from controller meltdown,
from poor connectivity on the SCSI bus, etc. (though I can imagine
that perhaps it isn't always easy to differentiate each of those in
software).  Having a solid clue to the real problem would save lots of
time (and money) troubleshooting.

I'm sure someone will suggest installing diagnostic utilities, but for
various reasons that's not possible in the short term.  Besides which
I'd generally like to understand the kernel messages anyway, but
preferably without the hundreds of hours it would take me to pour
over, research, and understand the kernel code.  Much as I'd love to
have time to be a kernel hacker, I just don't.

I'm also wondering if there is any plan to make the kernel messages
more generally intelligible to us common folk.  If there isn't, I'd
like to suggest it as a future feature enhancement. :)

Thanks much!

-- 
Derek D. Martin
http://www.pizzashack.org/
GPG Key ID: 0x81CFE75D

