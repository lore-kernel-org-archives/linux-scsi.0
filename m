From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] [SCSI] osd: fix signed char versus %02x issue
Date: Thu, 10 Dec 2015 14:13:45 -0500
Message-ID: <yq1fuza15hy.fsf@sermon.lab.mkp.net>
References: <1449584716-21093-1-git-send-email-linux@rasmusvillemoes.dk>
	<yq1zixi186s.fsf@sermon.lab.mkp.net>
	<CAHp75Vcze4m8OeY=0wuiUtE_LgoifmmhdRKM2sQTAT-_Y3DFjg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46904 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820AbbLJTOH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Dec 2015 14:14:07 -0500
In-Reply-To: <CAHp75Vcze4m8OeY=0wuiUtE_LgoifmmhdRKM2sQTAT-_Y3DFjg@mail.gmail.com>
	(Andy Shevchenko's message of "Thu, 10 Dec 2015 21:10:17 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Boaz Harrosh <ooo@electrozaur.com>, "James E.J. Bottomley" <JBottomley@odin.com>, osd-dev@open-osd.org, linux-scsi <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

>>>>> "Andy" == Andy Shevchenko <andy.shevchenko@gmail.com> writes:

Andy> I have several patches on SCSI subsytem like this one. Some of
Andy> them didn't manage kernel (even having Ack!) for years already.
Andy> Is it okay if I collect them together and send a bunch once again

Re-sending to linux-scsi is fine. The trick is finding people willing to
review them...

-- 
Martin K. Petersen	Oracle Linux Engineering
