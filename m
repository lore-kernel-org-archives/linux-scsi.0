From: Tim Pepper <tpepper@vato.org>
Subject: Re: Qlogic driver hang
Date: Thu, 2 Oct 2003 12:24:39 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031002122439.A17312@jose.vato.org>
References: <B179AE41C1147041AA1121F44614F0B060ED34@AVEXCH02.qlogic.org> <1065109530.24236.6127.camel@localhost.localdomain> <1065118590.4779.158.camel@persist.az.mvista.com> <3F7C6D9C.2000205@mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from adsl-64-142-13-48.sonic.net ([64.142.13.48]:38156 "HELO
	jose.vato.org") by vger.kernel.org with SMTP id S263365AbTJBTYX
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Oct 2003 15:24:23 -0400
Content-Disposition: inline
In-Reply-To: <3F7C6D9C.2000205@mvista.com>; from mbellon@mvista.com on Thu, Oct 02, 2003 at 11:25:32AM -0700
List-Id: linux-scsi@vger.kernel.org
To: Mark Bellon <mbellon@mvista.com>
Cc: sdake@mvista.com, Chris Worley <cworley@lnxi.com>, linux-scsi@vger.kernel.org

On Thu 02 Oct at 11:25:32 -0700 mbellon@mvista.com done said:
> >
> >
> >At one point some code was added to enable parity on the chip.  This may
> >be the cause of the hang.  Try disabling parity checking in the driver.

I think too that different bios flash version have different settings for
enabling/disabling parity (and other things) that can make a difference.
The latest on their webpage is 1.34.  I understand the firmware which the
driver downloads at load time still uses certain bits from the version
flashed to the card.  Somewhere around bios 1.2x (where x was something
high..it's been a while) I had some hangs go away.  All the new cards
I've gotten appear to ship with ancient BIOS's and sorely need flashing.

Tim
-- 
*********************************************************
*  tpepper@vato dot org             * Venimus, Vidimus, *
*  http://www.vato.org/~tpepper     * Dolavimus         *
*********************************************************
