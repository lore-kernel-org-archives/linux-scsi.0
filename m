From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch for 2.6.29? 2/2] scsi: mpt: suppress debugobjects
 warning
Date: Tue, 21 Apr 2009 09:58:43 -0700
Message-ID: <20090421095843.afc78b80.akpm@linux-foundation.org>
References: <200903042012.n24KCIKH030001@imap1.linux-foundation.org>
	<20090420145511.35b9c201.akpm@linux-foundation.org>
	<0D1E8821739E724A86F4D16902CE275C1410F4D5B1@inbmail01.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33654 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751705AbZDURC2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Apr 2009 13:02:28 -0400
In-Reply-To: <0D1E8821739E724A86F4D16902CE275C1410F4D5B1@inbmail01.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Cc: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "eparis@parisplace.org" <eparis@parisplace.org>, "Moore, Eric" <Eric.Moore@lsi.com>, "tglx@linutronix.de" <tglx@linutronix.de>

On Tue, 21 Apr 2009 16:08:45 +0530 "Desai, Kashyap" <Kashyap.Desai@lsi.com> wrote:

> It is a clean patch. There is not harm to ack it, but since I have already submitted code changes to upstream which have replaced "kernel timer" by "completion queue.", I will suggest to wait for next driver version.
> 
> Init_timer() function will not be called from MPT fusion driver in next version

No, that doesn't work.  This means that people who use 2.6.29 and
2.6.30 will potentially see these warnings.  This potentially includes
the customers of any distributors who enable debugobjects.

It creates additional work for users, for support staff and generates
concern about the stability of the kernel.


