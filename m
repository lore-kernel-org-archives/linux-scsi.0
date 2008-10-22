From: "Fabio Comolli" <fabio.comolli@gmail.com>
Subject: Re: Possible bug in SCSI Kconfig
Date: Wed, 22 Oct 2008 21:45:15 +0200
Message-ID: <b637ec0b0810221245p98f5837j58fdc505cf4fa131@mail.gmail.com>
References: <b637ec0b0810220929r2c889423ma92bef0ec7f9b3b0@mail.gmail.com>
	 <1224702340.6851.20.camel@localhost.localdomain>
	 <b637ec0b0810221225q589ed071i75f559d6fa76d96b@mail.gmail.com>
	 <20081022192650.GI26094@parisc-linux.org>
	 <b637ec0b0810221231w5a329e2cu84c8789e77a4eb59@mail.gmail.com>
	 <20081022193458.GJ26094@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gx0-f16.google.com ([209.85.217.16]:36919 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128AbYJVTpS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Oct 2008 15:45:18 -0400
Received: by gxk9 with SMTP id 9so90529gxk.13
        for <linux-scsi@vger.kernel.org>; Wed, 22 Oct 2008 12:45:17 -0700 (PDT)
In-Reply-To: <20081022193458.GJ26094@parisc-linux.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, sam@ravnborg.org, linux-scsi <linux-scsi@vger.kernel.org>

Hi.

On Wed, Oct 22, 2008 at 9:34 PM, Matthew Wilcox <matthew@wil.cx> wrote:
> On Wed, Oct 22, 2008 at 09:31:51PM +0200, Fabio Comolli wrote:
>> Unfortunately this is not an option because of ipw2200. I don't use
>> initrd and if I turn off CONFIG_MODULES the kernel hangs forever
>> requesting the firmware.
>
> Have you investigated CONFIG_EXTRA_FIRMWARE?

Wow! You made my day:

ipw2200: Intel(R) PRO/Wireless 2200/2915 Network Driver, 1.2.2kmr
ipw2200: Copyright(c) 2003-2006 Intel Corporation
ipw2200 0000:06:05.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
ipw2200: Detected Intel PRO/Wireless 2200BG Network Connection
firmware: using built-in firmware ipw2200-bss.fw

Thanks!

>
> --
> Matthew Wilcox                          Intel Open Source Technology Centre
> "Bill, look, we understand that you're interested in selling us this
> operating system, but compare it to ours.  We can't possibly take such
> a retrograde step."
>
