From: Douglas Gilbert <dougg@torque.net>
Subject: Re: Integration of SCST in the mainstream Linux kernel
Date: Mon, 04 Feb 2008 18:30:18 +0100
Message-ID: <47A74BAA.6080201@torque.net>
References: <e2e108260801230622x42045058v926e84c60f2be7f4@mail.gmail.com>	<1201639331.3069.58.camel@localhost.localdomain>	<47A05CBD.5050803@vlnb.net>	<47A7049A.9000105@vlnb.net>	<1202139015.3096.5.camel@localhost.localdomain>	<47A73C86.3060604@vlnb.net>	<1202144767.3096.38.camel@localhost.localdomain>	<47A7488B.4080000@vlnb.net>	<1202145901.3096.49.camel@localhost.localdomain>	<alpine.LFD.1.00.0802041018390.3034@hp.linux-foundation.org>	<1202151989.11265.576.camel@haakon2.linux-iscsi.org>	<alpine.LFD.1.00.0802041130140.3034@hp.linux-foundation.org> <20080204224314.113afe7b@core>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:38527 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757050AbYBDXas (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Feb 2008 18:30:48 -0500
In-Reply-To: <20080204224314.113afe7b@core>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Vladislav Bolkhovitin <vst@vlnb.net>, Bart Van Assche <bart.vanassche@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Mike Christie <michaelc@cs.wisc.edu>

Alan Cox wrote:
>> better. So for example, I personally suspect that ATA-over-ethernet is way 
>> better than some crazy SCSI-over-TCP crap, but I'm biased for simple and 
>> low-level, and against those crazy SCSI people to begin with.
> 
> Current ATAoE isn't. It can't support NCQ. A variant that did NCQ and IP
> would probably trash iSCSI for latency if nothing else.

And a variant that doesn't do ATA or IP:
http://www.fcoe.com/
