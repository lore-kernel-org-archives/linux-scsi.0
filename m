From: Ravi Anand <ravi.anand@qlogic.com>
Subject: Re: [PATCH 09/11] iscsi_transport: Added Ping support
Date: Tue, 21 Feb 2012 14:54:59 -0800
Message-ID: <062C30F4-2649-45E7-9158-1BC3DB35DE56@qlogic.com>
References: <1329138050-1042-1-git-send-email-vikas.chaudhary@qlogic.com>
 <1329138050-1042-10-git-send-email-vikas.chaudhary@qlogic.com>
 <CAJZOPZLdXtdLyTstWLu8A1Q454LD4k-0+HoDdqEHwFzbs+Ro6g@mail.gmail.com>
 <4F441BC5.4000301@cs.wisc.edu>
 <CAJZOPZKo5O8GMO9dz09UAvX8gHd5bT-Y2MdRkckh9dv2Q=m1jA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:49594
	"EHLO DB3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753122Ab2BUWzU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Feb 2012 17:55:20 -0500
In-Reply-To: <CAJZOPZKo5O8GMO9dz09UAvX8gHd5bT-Y2MdRkckh9dv2Q=m1jA@mail.gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Or Gerlitz <or.gerlitz@gmail.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>, "jbottomley@parallels.com" <jbottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Lalit Chandivade <lalit.chandivade@qlogic.com>


On Feb 21, 2012, at 2:39 PM, Or Gerlitz wrote:

> On Wed, Feb 22, 2012 at 12:33 AM, Mike Christie <michaelc@cs.wisc.edu> wrote:
>> This is network based. ICMP pings. The stuff we have today is iscsi
>> based pings. So you can do some basic network diag type of stuff.
>
> So what's wrong with plain ICMP pings... or is this is for
> cards/drivers which don't expose plain network interface to the
> kernel?
>
> Or.
>

Mike is correct - Btw QLogic iSCSI H/W Offload function is totally independent of NIC function.
Idea is that using iSCSI interface only, one can do network troubleshooting where it comes in handy.
You don't necessarily have to load NIC driver.

Ravi


This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

