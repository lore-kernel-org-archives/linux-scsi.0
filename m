From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: Reported regressions for 4.7 as of Sunday, 2016-06-19
Date: Tue, 05 Jul 2016 15:40:11 -0400
Message-ID: <yq1mvlvq3fo.fsf@sermon.lab.mkp.net>
References: <7cc588b7-f1cf-62a8-e45b-ec7d863ba51e@leemhuis.info>
	<CA+5PVA63r9xLXtiiVMxKPdgZD5VZ_8io1f=9MH520LAFBbe9kg@mail.gmail.com>
	<CA+55aFyyKjupjdd4tC82VEnZwb3AyEGJBVCJzdyvfgeUFGVfLw@mail.gmail.com>
	<yq1wpli2ewx.fsf@sermon.lab.mkp.net>
	<20160622115131.4bh7sh6uhmmhw44v@c203.arch.suse.de>
	<A19CCC3E-1B00-45A5-BA4B-2E082E98AF87@qlogic.com>
	<CA+5PVA6NVTQUPZBCZ7J+NV-fEPkGKk2DDNQHn80sv71NNYOJnA@mail.gmail.com>
	<CA+55aFzwVT4spevcuC5Ncee974w2QyxwVJ7RS_2YCEikkqKdGQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:44869 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105AbcGETkb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Jul 2016 15:40:31 -0400
In-Reply-To: <CA+55aFzwVT4spevcuC5Ncee974w2QyxwVJ7RS_2YCEikkqKdGQ@mail.gmail.com>
	(Linus Torvalds's message of "Tue, 5 Jul 2016 10:32:12 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Josh Boyer <jwboyer@fedoraproject.org>, Quinn Tran <quinn.tran@qlogic.com>, Johannes Thumshirn <jthumshirn@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Thorsten Leemhuis <regressions@leemhuis.info>, linux-kernel <linux-kernel@vger.kernel.org>, Linux SCSI List <linux-scsi@vger.kernel.org>

>>>>> "Linus" == Linus Torvalds <torvalds@linux-foundation.org> writes:

Linus> It's not in my tree, at least.

Not in scsi-fixes either. I have been waiting for a "real" patch
submission with one or more Tested-by: tags. I generally don't queue
something that comes with a "try this untested workaround" patch
description.

Quinn, please submit a real patch.

Linus> And I don't think I've seen a "yes, that fixes it". Although
Linus> Johannes was right that in addition to that, the ordering of the
Linus> irq setup should probably _also_ be fixed, but that's a separate
Linus> patch.

-- 
Martin K. Petersen	Oracle Linux Engineering
