From: Lukasz Kosewski <lkosewsk@gmail.com>
Subject: [PATCH 0/3] Add disk hotswap support to libata RESEND #2
Date: Mon, 1 Aug 2005 03:00:56 -0700
Message-ID: <355e5e5e0508010300d0aedc9@mail.gmail.com>
Reply-To: Lukasz Kosewski <lkosewsk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zproxy.gmail.com ([64.233.162.206]:29342 "EHLO zproxy.gmail.com")
	by vger.kernel.org with ESMTP id S262114AbVHAKA6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Aug 2005 06:00:58 -0400
Received: by zproxy.gmail.com with SMTP id r28so744195nza
        for <linux-scsi@vger.kernel.org>; Mon, 01 Aug 2005 03:00:56 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jgarzik@pobox.com
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Hey Jeff, all,

The following is my latest attempt at re-doing the hotswap patches for
libata hotswapping.  This has some positive upsides:

- The patches seem cleaner
- The patches seem more multi-purpose and adaptable for use across all
controllers, not just the Promise ones.
- Jeff is more likely to accept them since most of his suggestions
have been factored in.

There is also a downside:

- The patches haven't been tested at ALL since I don't have any
hardware until September.

So, try at your own risk.  Everything seems sane to me, however it is
3:00 AM here.

Jeff, these patches are designed against 2.6.13-rc3-mm1.  As a result,
they are meant to apply overtop of the sata_promise 'support PATA
port' patch.

Please apply and try.  And send me comments about how the patches are
broken in weird scenarios.

Luke Kosewski
