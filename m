From: Andries.Brouwer@cwi.nl
Subject: Re: scsi mode sense broken again
Date: Fri, 4 Jul 2003 23:08:06 +0200 (MEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <UTC200307042108.h64L86P22656.aeb@smtp.cwi.nl>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.cwi.nl ([192.16.191.8]:24970 "EHLO hera.cwi.nl")
	by vger.kernel.org with ESMTP id S266179AbTGDUxm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Jul 2003 16:53:42 -0400
List-Id: linux-scsi@vger.kernel.org
To: Andries.Brouwer@cwi.nl, mdharm-kernel@one-eyed-alien.net
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, torvalds@osdl.org

	From mdharm@ziggy.one-eyed-alien.net  Fri Jul  4 23:00:41 2003

	Do you still get the proper INQUIRY from 2.5.74?

Yes. But there is no need for you to worry.
This device just needs use_10_for_ms = 0.
When that is set all is well.

Andries
