From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: Re: [RFC PATCH 0/3] fix *pbl format support
Date: Mon, 21 Sep 2015 18:24:13 +0200
Message-ID: <87fv27lp02.fsf@rasmusvillemoes.dk>
References: <1442394523-19176-1-git-send-email-mlombard@redhat.com>
	<87d1xi4kic.fsf@rasmusvillemoes.dk>
	<20150916174536.GE3243@mtj.duckdns.org>
	<877fnq2jc0.fsf@rasmusvillemoes.dk> <56001A43.6050501@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:36912 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753345AbbIUQYQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Sep 2015 12:24:16 -0400
Received: by wicfx3 with SMTP id fx3so119362372wic.0
        for <linux-scsi@vger.kernel.org>; Mon, 21 Sep 2015 09:24:14 -0700 (PDT)
In-Reply-To: <56001A43.6050501@redhat.com> (Maurizio Lombardi's message of
	"Mon, 21 Sep 2015 16:54:59 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Maurizio Lombardi <mlombard@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, joe@perches.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, dgilbert@interlog.com

On Mon, Sep 21 2015, Maurizio Lombardi <mlombard@redhat.com> wrote:

> Hi Rasmus,
>
> On 09/16/2015 10:35 PM, Rasmus Villemoes wrote:
>> 
>> I just remembered: I noticed a while ago that the qualifier member is
>> only used inside format_decode (in the end, the information is folded
>> into the type member), so one might as well use a local variable for
>> that. This gives option (3): Make field_width a 24 bit bitfield. I think
>> that should be sufficient for any realistic bitmap that one would
>> print. The patch is also rather small. Surprisingly, bloat-o-meter even
>> says that it's also a net win in code size:
>
> I tested your patch with scsi-debug and it works for me:

Thanks for testing it! What do people think of this option?

Rasmus
