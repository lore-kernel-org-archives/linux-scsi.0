From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] m68k: mac_esp asm fix
Date: Tue, 18 Nov 2008 07:48:18 +0900
Message-ID: <1226962098.3403.16.camel@localhost.localdomain>
References: <Pine.LNX.4.64.0811172135200.14521@anakin>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:42249 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754544AbYKQWsX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Nov 2008 17:48:23 -0500
In-Reply-To: <Pine.LNX.4.64.0811172135200.14521@anakin>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-scsi@vger.kernel.org, Linux/m68k <linux-m68k@vger.kernel.org>

On Mon, 2008-11-17 at 21:37 +0100, Geert Uytterhoeven wrote:
> Can I queue it in the m68k tree for 2.6.29, or do you want it to go in through
> the SCSI tree?

There don't look to be any m68k dependencies, how about I take them both
through scsi-misc?

James


