From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [patch] drivers/scsi/dpt_i2o.c: fix a NULL pointer dereference
Date: Mon, 28 Nov 2005 12:37:11 -0600
Message-ID: <1133203032.3325.46.camel@mulgrave>
References: <20051126233637.GC3988@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:37841 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932130AbVK1Sig (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Nov 2005 13:38:36 -0500
In-Reply-To: <20051126233637.GC3988@stusta.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@stusta.de>
Cc: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>, Marcelo Tosatti <marcelo.tosatti@cyclades.com>, markus.lidel@shadowconnect.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Mark Salyzyn <mark_salyzyn@adaptec.com>

On Sun, 2005-11-27 at 00:36 +0100, Adrian Bunk wrote:
> The Coverity checker spotted this obvious NULL pointer dereference.

It's a bit late for this one, since Linus already put it in, but for
future reference, could you please try to use proper descriptions.  This
isn't an "obvious NULL pointer dereference", it's actually a use after
free of a data structure.

Thanks,

James


