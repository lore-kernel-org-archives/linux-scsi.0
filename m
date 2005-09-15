From: Lukasz Kosewski <lkosewsk@gmail.com>
Subject: [PATCH 2.6.14-rc1 0/3] Add disk hotswap support to libata RESEND #3
Date: Thu, 15 Sep 2005 01:04:42 -0400
Message-ID: <355e5e5e050914220444505b09@mail.gmail.com>
Reply-To: lkosewsk@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zproxy.gmail.com ([64.233.162.201]:52764 "EHLO zproxy.gmail.com")
	by vger.kernel.org with ESMTP id S965147AbVIOFEp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Sep 2005 01:04:45 -0400
Received: by zproxy.gmail.com with SMTP id i11so197235nzi
        for <linux-scsi@vger.kernel.org>; Wed, 14 Sep 2005 22:04:42 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org

Hello Jeff, all,

Another attempt at hotswap support to libata... this would be attempt #3.

Lots of improvements... a cleaner API, clean straightforward code
which is easy to customize (or generalize, when the desire to support
ATA hotswap comes along), and a new feature; no longer kernel panics
on any action!

Some testing on x86 UP, minimal on SMP.  Please test, send questions,
suggestions, and apply if you like it.  Patches apply cleanly to
2.6.14-rc1.  I've got some hardware so if you discover problems I can
probably reproduce them.

Enjoy,

Luke Kosewski
