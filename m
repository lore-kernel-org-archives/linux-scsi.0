From: "Monty Montgomery" <monty@xiph.org>
Subject: Re: [regression] CD-DA delay needed after insertion (http://bugzilla.kernel.org/show_bug.cgi?id=10974)
Date: Tue, 30 Sep 2008 13:32:15 -0400
Message-ID: <806dafc20809301032n559832et45f3bf5e3f7c495c@mail.gmail.com>
References: <Pine.LNX.4.64.0806131352360.2141@vixen.sonytel.be>
	 <1214925487.3316.12.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0809171701330.21347@vixen.sonytel.be>
	 <806dafc20809300117u2806e37bx986b54543862f358@mail.gmail.com>
	 <Pine.LNX.4.64.0809301430370.5818@vixen.sonytel.be>
	 <806dafc20809300548y4af5f10bs8a80caa24f176c79@mail.gmail.com>
	 <806dafc20809300551i7678660aq5e4fd6e8080382a0@mail.gmail.com>
	 <Pine.LNX.4.64.0809301648490.5818@vixen.sonytel.be>
	 <806dafc20809300807h6d38bbeex2f2b4e496b0d155c@mail.gmail.com>
	 <Pine.LNX.4.64.0809301719000.5818@vixen.sonytel.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gx0-f16.google.com ([209.85.217.16]:58061 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752588AbYI3RcR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Sep 2008 13:32:17 -0400
Received: by gxk9 with SMTP id 9so12068657gxk.13
        for <linux-scsi@vger.kernel.org>; Tue, 30 Sep 2008 10:32:15 -0700 (PDT)
In-Reply-To: <Pine.LNX.4.64.0809301719000.5818@vixen.sonytel.be>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Linux Kernel Development <linux-kernel@vger.kernel.org>

On Tue, Sep 30, 2008 at 11:21 AM, Geert Uytterhoeven
<Geert.Uytterhoeven@sonycom.com> wrote:

>> (May I ask-- why the hard starting/stopping of the interface?  Power saving?]
>
> Which hard starting/stopping do you mean?

why the calls to sg_start?

Monty
