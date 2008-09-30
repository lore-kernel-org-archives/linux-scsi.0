From: "Monty Montgomery" <monty@xiph.org>
Subject: Re: [regression] CD-DA delay needed after insertion (http://bugzilla.kernel.org/show_bug.cgi?id=10974)
Date: Tue, 30 Sep 2008 11:07:34 -0400
Message-ID: <806dafc20809300807h6d38bbeex2f2b4e496b0d155c@mail.gmail.com>
References: <Pine.LNX.4.64.0806131352360.2141@vixen.sonytel.be>
	 <Pine.LNX.4.64.0806301120570.10868@vixen.sonytel.be>
	 <1214841102.3381.5.camel@localhost.localdomain>
	 <1214925487.3316.12.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0809171701330.21347@vixen.sonytel.be>
	 <806dafc20809300117u2806e37bx986b54543862f358@mail.gmail.com>
	 <Pine.LNX.4.64.0809301430370.5818@vixen.sonytel.be>
	 <806dafc20809300548y4af5f10bs8a80caa24f176c79@mail.gmail.com>
	 <806dafc20809300551i7678660aq5e4fd6e8080382a0@mail.gmail.com>
	 <Pine.LNX.4.64.0809301648490.5818@vixen.sonytel.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gx0-f16.google.com ([209.85.217.16]:44864 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838AbYI3PHg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Sep 2008 11:07:36 -0400
Received: by gxk9 with SMTP id 9so11830590gxk.13
        for <linux-scsi@vger.kernel.org>; Tue, 30 Sep 2008 08:07:34 -0700 (PDT)
In-Reply-To: <Pine.LNX.4.64.0809301648490.5818@vixen.sonytel.be>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Linux Kernel Development <linux-kernel@vger.kernel.org>

> With latest cdparanoia git-^H^H^H^Hsvn, the problem still happens.
> After applying the patch below, there's no more crash thanks to your last
> commit, and It Just Works(tm):

Then I will be doing some headscratching over a copy of the kernel.
Oh--  what *exact* kernel are you using?  non-x86 trees don't always
sync often with the 'official' mainline and I want to be sure I'm
reading the correct thing.  I was a longtime PPC user until about two
years ago, and I'm used to there being several substantially different
PPC kernel trees [just making sure].

OTOH, if the kernel isn't even servicing the device as a block device
until the drive returns a ready status and O_NONBLOCK thwarts waiting
for that.... sigh.  Nothing like a passthrough interface that still
isn't a passthrough interface after fifteen years of dicking around.

I'm not willing to cripple cdparanoia on more-than-one-cdrom systems
because of an edge case due to yet another ill-considered block layer
'feature'.  For one thing *I* need to be able to scan devices without
blocking on my own multiple drive systems.  If there's a workaround to
get both, I will find it.

But it's too early to say for sure.  I'll check again.

(May I ask-- why the hard starting/stopping of the interface?  Power saving?]

Monty
