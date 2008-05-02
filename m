From: Roland Dreier <rdreier@cisco.com>
Subject: Re: HELP: Is writeq an atomic operation??
Date: Fri, 02 May 2008 15:53:28 -0700
Message-ID: <adawsmc2u8n.fsf@cisco.com>
References: <0631C836DBF79F42B5A60C8C8D4E822901047B3A@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-2.cisco.com ([171.71.176.71]:46171 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759362AbYEBWxa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 May 2008 18:53:30 -0400
In-Reply-To: <0631C836DBF79F42B5A60C8C8D4E822901047B3A@NAMAIL2.ad.lsil.com>
	(Eric Moore's message of "Fri, 2 May 2008 16:49:55 -0600")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsi.com>
Cc: David Miller <davem@davemloft.net>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

 > > Are there any 32-bit platforms with writeq()?  A quick grep 
 > > suggests not.
 > 
 > I think writeq defined in include/asm-x86/io_64.h

Umm... io_64.h is 64-bit only (look at asm-x86/io.h if you don't believe me ;)

 - R.
