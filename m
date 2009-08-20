From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: oops during scsi scanning disk setup
Date: Thu, 20 Aug 2009 14:01:04 -0600
Message-ID: <20090820200104.GH11966@parisc-linux.org>
References: <20090820180549.GD7542@arachsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:33577 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755319AbZHTUBD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Aug 2009 16:01:03 -0400
Content-Disposition: inline
In-Reply-To: <20090820180549.GD7542@arachsys.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chris Webb <chris@arachsys.com>
Cc: linux-scsi@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>

On Thu, Aug 20, 2009 at 07:05:49PM +0100, Chris Webb wrote:
> in Linux 2.6.30.4 x86-64 with async scsi bus scanning turned on. I've now
> seen it again a couple of times with CONFIG_SCSI_SCAN_ASYNC turned off. The
> machine locks up hard shortly after the oops.

^^^ that option

> I'm not quite clear how I can be in sd_probe_async when asynchronous bus
> scanning is compiled out completely, but perhaps I'm misunderstanding how
> this function is used.

^^^ has nothing to do with sd_probe_async.

I wrote the code covered by the former, and it's really annoying me
that people keep reporting it as buggy, when it's actually the code in
kernel/async.c that's buggy.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
