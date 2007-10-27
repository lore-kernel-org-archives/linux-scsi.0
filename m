From: "Robert P. J. Day" <rpjday@crashcourse.ca>
Subject: Re: single unused scsi-related CONFIG variable
Date: Sat, 27 Oct 2007 00:28:03 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0710270022150.30030@localhost.localdomain>
References: <Pine.LNX.4.64.0710261417230.2937@localhost.localdomain>
 <20071026212105.c74d2f6b.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from astoria.ccjclearline.com ([64.235.106.9]:44552 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900AbXJ0EbE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 27 Oct 2007 00:31:04 -0400
In-Reply-To: <20071026212105.c74d2f6b.rdunlap@xenotime.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: linux-scsi@vger.kernel.org

On Fri, 26 Oct 2007, Randy Dunlap wrote:

> On Fri, 26 Oct 2007 14:18:05 -0400 (EDT) Robert P. J. Day wrote:
>
> >
> > drivers/scsi/Kconfig:1322:config SCSI_QLOGIC_FC_FIRMWARE
>
> config SCSI_QLOGIC_FC_FIRMWARE
> 	bool "Include loadable firmware in driver"
> 	depends on SCSI_QLOGIC_FC
>
>
> I don't find SCSI_QLOGIC_FC defined anywhere...

i'm just *guessing* that some SCSI_QLOGIC_FC-related logic existed
once upon a time, it was removed, but the controlling Kconfig entry
was overlooked.

so it would seem safe to just blast that single config entry above,
no?  i can whip up a patch for that shortly.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
