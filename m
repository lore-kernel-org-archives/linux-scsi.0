From: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Subject: RE: [patch for 2.6.29? 2/2] scsi: mpt: suppress debugobjects warning
Date: Tue, 21 Apr 2009 23:33:31 +0530
Message-ID: <0D1E8821739E724A86F4D16902CE275C1410F4D623@inbmail01.lsi.com>
References: <200903042012.n24KCIKH030001@imap1.linux-foundation.org>
	<20090420145511.35b9c201.akpm@linux-foundation.org>
	<0D1E8821739E724A86F4D16902CE275C1410F4D5B1@inbmail01.lsi.com>
 <20090421095843.afc78b80.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from chip3og56.obsmtp.com ([64.18.14.177]:41555 "EHLO
	chip3og56.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752786AbZDUSEi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Apr 2009 14:04:38 -0400
In-Reply-To: <20090421095843.afc78b80.akpm@linux-foundation.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "eparis@parisplace.org" <eparis@parisplace.org>, "Moore, Eric" <Eric.Moore@lsi.com>, "tglx@linutronix.de" <tglx@linutronix.de>

It is good to consider this patch as approved; even thought timer function which is causing this problem is replaced by completion queue in future. 
Lets consider this patch as ACKED.

- Kashyap

-----Original Message-----
From: Andrew Morton [mailto:akpm@linux-foundation.org] 
Sent: Tuesday, April 21, 2009 10:29 PM
To: Desai, Kashyap
Cc: James.Bottomley@HansenPartnership.com; linux-scsi@vger.kernel.org; eparis@parisplace.org; Moore, Eric; tglx@linutronix.de
Subject: Re: [patch for 2.6.29? 2/2] scsi: mpt: suppress debugobjects warning

On Tue, 21 Apr 2009 16:08:45 +0530 "Desai, Kashyap" <Kashyap.Desai@lsi.com> wrote:

> It is a clean patch. There is not harm to ack it, but since I have already submitted code changes to upstream which have replaced "kernel timer" by "completion queue.", I will suggest to wait for next driver version.
> 
> Init_timer() function will not be called from MPT fusion driver in next version

No, that doesn't work.  This means that people who use 2.6.29 and
2.6.30 will potentially see these warnings.  This potentially includes
the customers of any distributors who enable debugobjects.

It creates additional work for users, for support staff and generates
concern about the stability of the kernel.


