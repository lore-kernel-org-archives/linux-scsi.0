From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Re: Linux 2.6.28-rc1] scsi 4:0:0:0: timing out command, waited
 22s
Date: Fri, 24 Oct 2008 11:04:54 -0700 (PDT)
Message-ID: <alpine.LFD.2.00.0810241103100.3287@nehalem.linux-foundation.org>
References: <8db1092f0810241057j51f0b70eo3cea4499422f0d38@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33245 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754466AbYJXSE5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Oct 2008 14:04:57 -0400
In-Reply-To: <8db1092f0810241057j51f0b70eo3cea4499422f0d38@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Maciej Rutecki <maciej.rutecki@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org, SCSI development list <linux-scsi@vger.kernel.org>



On Fri, 24 Oct 2008, Maciej Rutecki wrote:
>
> During boot I have this message:

It's almost certainly the broken support for non-NCQ. Fixed in -git by:

	http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=e013e13bf605b9e6b702adffbe2853cfc60e7806

oh, well.

		Linus
