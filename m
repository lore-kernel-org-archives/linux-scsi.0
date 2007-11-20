From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [Bugme-new] [Bug 9405] New: iSCSI does not implement ordering guarantees required by e.g. journaling filesystems
Date: Tue, 20 Nov 2007 10:52:39 -0700
Message-ID: <20071120175239.GI12494@parisc-linux.org>
References: <1195505766.3963.1.camel@localhost.localdomain> <4741FE89.4020307@cs.wisc.edu> <1195507720.3963.4.camel@localhost.localdomain> <4742F78B.8010004@vlnb.net> <1195572482.3131.28.camel@localhost.localdomain> <4743082D.7030302@vlnb.net> <1195577040.3131.48.camel@localhost.localdomain> <47431697.3080901@vlnb.net> <1195579841.3131.60.camel@localhost.localdomain> <47431D28.9020708@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:39715 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757646AbXKTRwk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Nov 2007 12:52:40 -0500
Content-Disposition: inline
In-Reply-To: <47431D28.9020708@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Mike Christie <michaelc@cs.wisc.edu>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, bugme-daemon@bugzilla.kernel.org, bart.vanassche@gmail.com

On Tue, Nov 20, 2007 at 08:45:12PM +0300, Vladislav Bolkhovitin wrote:
> James Bottomley wrote:
> >We handle TASK ABORTED as well as we can (by failing it).  For better
> >handling set TAS=0 and we'll handle the individual cases according to
> >the sense codes.
> 
> So, should I consider your words as you think that it's perfectly fine 
> to corrupt file system for devices with TAS=1? Absolutely legal devices, 
> repeat. Hence, in your opinion, no further investigation should be done?

I don't know how you manage to read his words this way.  I understand
him to mean that the SCSI subsystem is doing the best in can under the
somewhat misconfigured circumstances, and the problem lies in the FS not
handling errors correctly.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
