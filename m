From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Intel X25-M MLC SSD benchmarks
Date: Fri, 12 Dec 2008 08:20:29 -0700
Message-ID: <20081212152029.GL26095@parisc-linux.org>
References: <20081210213937.GC25548@parisc-linux.org> <83CA05F64804AF43B8F733C4ABDFAA51022D04D7@mail1.bitband.com> <311601c90812111927t54ed6a54oac3154dba30f737d@mail.gmail.com> <311601c90812112055i7ec955d6kf4fc13279817cdb0@mail.gmail.com> <e2e108260812112315q5ed1d265q86cf22b1dd59c69d@mail.gmail.com> <311601c90812120625o4e000646u98aebc8ab3556a33@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:43538 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756767AbYLLPUq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Dec 2008 10:20:46 -0500
Content-Disposition: inline
In-Reply-To: <311601c90812120625o4e000646u98aebc8ab3556a33@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Eric D. Mudama" <edmudama@gmail.com>
Cc: Bart Van Assche <bart.vanassche@gmail.com>, Raz Ben-Yehuda <razb@bitband.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, Dec 12, 2008 at 07:25:18AM -0700, Eric D. Mudama wrote:
> Oops, I guess I assumed that by writing a few gigabytes of data it
> wouldn't matter that much.  I'll run the test again in a bit once I'm
> off this solaris machine.

You need to rescale for 2008; people often have 4GB or more RAM in their
machines ... hell, I have one machine here from 2002 with 14GB in it
(I don't power it up very often because it's too noisy).  The test was
only writing 1GB of data, which would fit in the page cache of my laptop,
never mind the kind of machine that's likely to have an 8-way array
attached to it.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
