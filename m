From: Or Gerlitz <ogerlitz@voltaire.com>
Subject: Re: build failure of drivers/scsi/gdth.c
Date: Tue, 18 Jan 2011 09:39:18 +0200
Message-ID: <4D3543A6.8040909@voltaire.com>
References: <Pine.LNX.4.64.1101121217090.6323@zuben.voltaire.com>	<20110112083919.494a7404.rdunlap@xenotime.net>	<AANLkTikmygrH_W=nTB2ERPjUETVNzW=8n7VL9Jf6DLu3@mail.gmail.com> <20110113091127.dcdd3105.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fwil.voltaire.com ([193.47.165.2]:12096 "EHLO
	Exil2010.voltaire.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751433Ab1ARHjV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Jan 2011 02:39:21 -0500
In-Reply-To: <20110113091127.dcdd3105.rdunlap@xenotime.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Or Gerlitz <or.gerlitz@gmail.com>, linux-scsi@vger.kernel.org

Randy Dunlap wrote:
> It builds OK for me.

okay, maybe something else is broken on my build environment, I'll send
you off list the compressed verbose build log, the problem I'm not spotting
is why LINUX_VERSION_CODE is defined to nothing in my env. I'm hitting this
error on drivers/scsi/gdth.c and some other code that look on that constant,
luckily there aren't many drivers doing that...

Or.
