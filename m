From: Andries.Brouwer@cwi.nl
Subject: Re: scsi mode sense broken again
Date: Fri, 4 Jul 2003 23:25:12 +0200 (MEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <UTC200307042125.h64LPCq07319.aeb@smtp.cwi.nl>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.cwi.nl ([192.16.191.8]:11406 "EHLO hera.cwi.nl")
	by vger.kernel.org with ESMTP id S266192AbTGDVKr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Jul 2003 17:10:47 -0400
List-Id: linux-scsi@vger.kernel.org
To: Andries.Brouwer@cwi.nl, mdharm-kernel@one-eyed-alien.net
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, torvalds@osdl.org

    From mdharm@ziggy.one-eyed-alien.net  Fri Jul  4 23:09:37 2003

    Okay, so the question as I see it is this:
    Do we go back to use_10_for_ms = 0 for the default,
    or do we make the IMM driver set it to 0 in the
    slave_configure() function?

I agree completely - that is the question.
The answer I gave is

  -       sdev->use_10_for_ms = 1;
  +       sdev->use_10_for_ms = 0;
 
  It is possible to have use_10_for_ms == 1 as the default, but then
  all drivers that cannot handle that must change that setting privately.
  Maybe that is the future, but for today I would prefer
  the known working version.

Andries
