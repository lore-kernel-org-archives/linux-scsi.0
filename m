From: Andries.Brouwer@cwi.nl
Subject: scsi mode sense broken again
Date: Fri, 4 Jul 2003 01:06:17 +0200 (MEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <UTC200307032306.h63N6HQ26283.aeb@smtp.cwi.nl>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.cwi.nl ([192.16.191.8]:45002 "EHLO hera.cwi.nl")
	by vger.kernel.org with ESMTP id S265488AbTGCWvz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Jul 2003 18:51:55 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, torvalds@osdl.org

For me 2.5.72 works, 2.5.74 does not - no working ZIP drive.
The cause is the recent fiddling of use_10 / do_mode_sense.
If this is known and has a patch on the way all is well.
Otherwise I can send a patch.

Andries

(It feels as if I have to repair this area every other month.)

