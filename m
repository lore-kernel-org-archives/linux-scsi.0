From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: Re: [PATCH v2 0/6] scsi: Some seq_file cleanups/optimizations
Date: Wed, 21 Jan 2015 13:08:17 +0100
Message-ID: <873874uyj2.fsf@rasmusvillemoes.dk>
References: <1417221258-4937-1-git-send-email-linux@rasmusvillemoes.dk>
	<1417561854-17188-1-git-send-email-linux@rasmusvillemoes.dk>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-la0-f42.google.com ([209.85.215.42]:40129 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742AbbAUMIV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Jan 2015 07:08:21 -0500
Received: by mail-la0-f42.google.com with SMTP id ms9so17521466lab.1
        for <linux-scsi@vger.kernel.org>; Wed, 21 Jan 2015 04:08:19 -0800 (PST)
In-Reply-To: <1417561854-17188-1-git-send-email-linux@rasmusvillemoes.dk>
	(Rasmus Villemoes's message of "Wed, 3 Dec 2014 00:10:48 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Finn Thain <fthain@telegraphics.com.au>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, Dec 03 2014, Rasmus Villemoes <linux@rasmusvillemoes.dk> wrote:

> These patches mostly replace seq_printf with simpler and faster
> equivalents, e.g. seq_printf(m, "something") => seq_puts(m,
> "something") and seq_printf(m, "\n") => seq_putc(m, '\n). But before
> my Coccinelle scripts could be unleashed I had to clean up an
> unnecessary macro.
>
> The patches don't change the semantics of the code (well, that's the
> idea anyway), but should make it slightly smaller and faster.
>
> v2: Redone on top of git://git.infradead.org/users/hch/scsi-queue.git drivers-for-3.19
>

Ping. Was this picked up, or did it just go to /dev/null?

Rasmus
