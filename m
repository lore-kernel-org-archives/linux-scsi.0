From: Andries.Brouwer@cwi.nl
Subject: Re: [PATCH] kill two scsi ioctls
Date: Thu, 10 Apr 2003 19:29:11 +0200 (MEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <UTC200304101729.h3AHTB426607.aeb@smtp.cwi.nl>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.cwi.nl ([192.16.191.8]:54924 "EHLO hera.cwi.nl")
	by vger.kernel.org with ESMTP id S264108AbTDJRRb (for <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Apr 2003 13:17:31 -0400
List-Id: linux-scsi@vger.kernel.org
To: Andries.Brouwer@cwi.nl, levon@movementarian.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, torvalds@transmeta.com

    On Thu, Apr 10, 2003 at 06:33:26PM +0200, Andries.Brouwer@cwi.nl wrote:

    > The definition for SCSI_IOCTL_BENCHMARK_COMMAND was added in 1.1.2.
    > The definition for SCSI_IOCTL_SYNC was added in 1.1.38.
    > Neither of them has ever been used.

    Can't you at least add a comment about what was there ? It's quite
    annoying to come across :

    #define FOO 1
    #define BAR 2
    #define BAZ 5

    and have no idea why

It happens all the time. Hundreds of cases.

I prefer a short and clean actual kernel source, and long
historical explanations somewhere else, for example in
Documentation/ioctl_list.

(Michael Elizabeth Chastain made ioctl_list.2 a man page,
but nobody keeps it up-to-date. The current version is from
1.3.27. I am updating it and expect to submit it for the
Documentation directory. Maybe more people will update it there.)

Andries
