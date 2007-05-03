From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: dead CONFIG_ variables:  drivers/scsi/
Date: Thu, 03 May 2007 13:35:56 +0200
Message-ID: <4639C91C.9070204@s5r6.in-berlin.de>
References: <Pine.LNX.4.64.0705030606570.32341@localhost.localdomain> <20070503111113.GC12018@flint.arm.linux.org.uk> <Pine.LNX.4.64.0705030713210.680@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:38210 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753873AbXECLgs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 May 2007 07:36:48 -0400
In-Reply-To: <Pine.LNX.4.64.0705030713210.680@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

Robert P. J. Day wrote:
[...]
>> > drivers/scsi/arm/acornscsi.c:70:#undef CONFIG_SCSI_ACORNSCSI_LINK
>> > drivers/scsi/arm/acornscsi.c:169:#ifdef CONFIG_SCSI_ACORNSCSI_LINK
[...]
> p.s.  "CONFIG_" prefix aside, i would think it's also a bit yucky to
> be checking for the definition of a preprocessor symbol that you've
> already hardcoded out of existence in the same source file.  :-)

These are basically #if 0 ... #endif blocks with an activation switch
conveniently placed at the top of the .c file.  In the quoted example,
the effect of the activation switch is also documented by a comment.

Of course we should restrain ourselves WRT the use of #if 0 ... #endif
blocks in in-tree code, but sometimes they have sensible applications.
-- 
Stefan Richter
-=====-=-=== -=-= ---==
http://arcgraph.de/sr/
