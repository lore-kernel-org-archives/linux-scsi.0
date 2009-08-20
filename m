From: Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: oops during scsi scanning disk setup
Date: Thu, 20 Aug 2009 13:10:51 -0700
Message-ID: <86802c440908201310v501c11afid4a8f041825f9d28@mail.gmail.com>
References: <20090820180549.GD7542@arachsys.com>
	 <20090820200104.GH11966@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gx0-f205.google.com ([209.85.217.205]:40154 "EHLO
	mail-gx0-f205.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051AbZHTUKu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Aug 2009 16:10:50 -0400
Received: by gxk1 with SMTP id 1so197805gxk.17
        for <linux-scsi@vger.kernel.org>; Thu, 20 Aug 2009 13:10:51 -0700 (PDT)
In-Reply-To: <20090820200104.GH11966@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>, Jeff Garzik <jgarzik@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: Chris Webb <chris@arachsys.com>, linux-scsi@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>

On Thu, Aug 20, 2009 at 1:01 PM, Matthew Wilcox<matthew@wil.cx> wrote:
> On Thu, Aug 20, 2009 at 07:05:49PM +0100, Chris Webb wrote:
>> in Linux 2.6.30.4 x86-64 with async scsi bus scanning turned on. I've now
>> seen it again a couple of times with CONFIG_SCSI_SCAN_ASYNC turned off. The
>> machine locks up hard shortly after the oops.
>
> ^^^ that option
>
>> I'm not quite clear how I can be in sd_probe_async when asynchronous bus
>> scanning is compiled out completely, but perhaps I'm misunderstanding how
>> this function is used.
>
> ^^^ has nothing to do with sd_probe_async.
>
> I wrote the code covered by the former, and it's really annoying me
> that people keep reporting it as buggy, when it's actually the code in
> kernel/async.c that's buggy.

anyway to disable that? should have something like fastboot=off or nofastboot

YH
