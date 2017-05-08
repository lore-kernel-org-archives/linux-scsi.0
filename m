From: Richard Weinberger <richard.weinberger@gmail.com>
Subject: Re: Race to power off harming SATA SSDs
Date: Mon, 8 May 2017 11:51:40 +0200
Message-ID: <CAFLxGvydhh7XWSQHKpNnuMS0GvU+Edovdm1MeYwiSiBAi_rwgg@mail.gmail.com>
References: <20170410232118.GA4816@khazad-dum.debian.net> <20170410235206.GA28603@wtj.duckdns.org>
 <20170507204007.GA25628@atrey.karlin.mff.cuni.cz> <1494228094.6528.14.camel@infradead.org>
 <20170508092846.GA11029@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f50.google.com ([209.85.218.50]:36530 "EHLO
        mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752759AbdEHJvm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 May 2017 05:51:42 -0400
In-Reply-To: <20170508092846.GA11029@amd>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Pavel Machek <pavel@ucw.cz>
Cc: David Woodhouse <dwmw2@infradead.org>, Tejun Heo <tj@kernel.org>, Henrique de Moraes Holschuh <hmh@hmh.eng.br>, LKML <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-ide@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>, Boris Brezillon <boris.brezillon@free-electrons.com>, "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>

Pavel,

On Mon, May 8, 2017 at 11:28 AM, Pavel Machek <pavel@ucw.cz> wrote:
> Are you sure you have it right in JFFS2? Do you journal block erases?
> Apparently, that was pretty much non-issue on older flashes.

This is what the website says, yes. Do you have hardware where you can
trigger it?
If so, I'd love to get access to it.

So far I never saw the issue, sometimes people claim to suffer from it
but when I
inspect the problems in detail it is always something else.

-- 
Thanks,
//richard
