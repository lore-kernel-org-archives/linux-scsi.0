From: =?ISO-8859-1?Q?Gunter_K=F6nigsmann?= <gunter@peterpall.de>
Subject: Minor bug un scsi.h?
Date: Sun, 18 Jan 2004 17:43:43 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.53.0401181220490.18346@calcula.uni-erlangen.de>
Reply-To: =?ISO-8859-1?Q?Gunter_K=F6nigsmann?= <gunter.koenigsmann@gmx.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.185]:43491 "EHLO
	moutng.kundenserver.de") by vger.kernel.org with ESMTP
	id S262015AbUARQl5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 18 Jan 2004 11:41:57 -0500
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: linux-scsi@vger.kernel.org


Hello, there!

Seems there is a little bug in either cdrdao and cdrecord or in
linux-2.6.1:

When including include/scsi/scsi.h, the variable type u8 is undefined, but
needed there. The definition seems to be in include/asm-arch/types.h.

Didn't have problems with Linux-2.4.20.


Yours,

	Gunter.
