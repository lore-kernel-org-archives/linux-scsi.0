From: Andrew Morton <akpm@osdl.org>
Subject: Re: AIC7xxx on 2.6.18
Date: Sun, 28 Jan 2007 16:24:08 -0800
Message-ID: <20070128162408.9fffb6de.akpm@osdl.org>
References: <20070128194620.GA6358@animx.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43354 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932997AbXA2AYV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 28 Jan 2007 19:24:21 -0500
In-Reply-To: <20070128194620.GA6358@animx.eu.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Wakko Warner <wakko@animx.eu.org>
Cc: linux-scsi@vger.kernel.org


(switched mailing lists)

On Sun, 28 Jan 2007 14:46:20 -0500
Wakko Warner <wakko@animx.eu.org> wrote:

> I have 2 machine that oops with these cards.
> 
> 1) The bios has the option to enable/disable option roms on individual PCI
> slots.  I have an AHA-39160 and an AHA-2940U/UW (dual channel).  If I
> disable option roms, the driver oopses when accessing the 2nd card.
> 
> I can get the oops if really needed as I don't like rebooting this machine.
> 
> 2) I have an AHA-39160 with Apple/Mac firmware.  When attempting to use it
> on a PC, the driver oopses presumably because the card wasn't initialized or
> something.  I realize this is probably not a supported configuration, but I
> don't believe that it should be oopsing.
> 
> I can get the oops for this one if it'll help.

Yes, getting the oops traces will help, thanks.  And confirmation on a more
recent kernel would be good.



