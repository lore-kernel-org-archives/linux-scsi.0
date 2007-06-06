From: Douglas Gilbert <dougg@torque.net>
Subject: Re: Very slow writes with mptsas
Date: Wed, 06 Jun 2007 20:06:24 +0200
Message-ID: <4666F7A0.8080605@torque.net>
References: <20070605161620.GB6519@bloch.config> <7579f7fb0706052232x44db1f7he88a50646a3c57db@mail.gmail.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:57761 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759459AbXFFSGu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jun 2007 14:06:50 -0400
In-Reply-To: <7579f7fb0706052232x44db1f7he88a50646a3c57db@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Jacob <lydianconcepts@gmail.com>
Cc: "bloch@verdurin.com" <bloch@verdurin.com>, linux-scsi@vger.kernel.org, linux-precision@dell.com

Matthew Jacob wrote:
> The FreeBSD problem was fixed by Scott Long a couple of days ago by
> doing some cut through SAS stuff that enabled Write Cache for SATA
> drives. Why LSI-Logic couldn't just blitheringly synthesize mode page
> 8 is beyond me, but okay.
> 
> I dunno whether the issue here is the same one Scott tackled- probably
> given the messages. Eric- you listening in on this?

Matt,
Just in case Eric doesn't answer, I suspect if the
HBA firmware can be upgraded (from Dell or LSI?) then
WCE (write cache enable) in the caching mode page
will be supported. It is one of the few mode page
settings that is required to be implemented in SAT.

The other field that should be changeable is DRA
(disable read ahead). Both work on my LSI SAS HBA.

Doug Gilbert

