From: Mark Bellon <mbellon@mvista.com>
Subject: Re: Qlogic driver hang
Date: Thu, 02 Oct 2003 12:43:56 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3F7C7FFC.9070406@mvista.com>
References: <B179AE41C1147041AA1121F44614F0B060ED34@AVEXCH02.qlogic.org> <1065109530.24236.6127.camel@localhost.localdomain> <1065118590.4779.158.camel@persist.az.mvista.com> <3F7C6D9C.2000205@mvista.com> <20031002122439.A17312@jose.vato.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gateway-1237.mvista.com ([12.44.186.158]:10749 "EHLO
	av.mvista.com") by vger.kernel.org with ESMTP id S263463AbTJBToE
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Oct 2003 15:44:04 -0400
In-Reply-To: <20031002122439.A17312@jose.vato.org>
List-Id: linux-scsi@vger.kernel.org
To: Tim Pepper <tpepper@vato.org>
Cc: sdake@mvista.com, Chris Worley <cworley@lnxi.com>, linux-scsi@vger.kernel.org

>
>
>I think too that different bios flash version have different settings for
>enabling/disabling parity (and other things) that can make a difference.
>The latest on their webpage is 1.34.  I understand the firmware which the
>driver downloads at load time still uses certain bits from the version
>flashed to the card.  Somewhere around bios 1.2x (where x was something
>high..it's been a while) I had some hangs go away.  All the new cards
>I've gotten appear to ship with ancient BIOS's and sorely need flashing.
>  
>
The driver supports a compiled in version of the firmware and, at last 
look, always uses that regardless of what in out there in non-volatile 
storage. The firmware compiled into the 6.06 driver is 3.02.13 for the 
23xx. This is a relatively new firmware.

By-the-by, which HBA is being used?

mark


