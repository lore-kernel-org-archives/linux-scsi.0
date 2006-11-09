From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Support for (new?) Silicon Image PCI SATA controller
Date: Thu, 9 Nov 2006 16:40:10 -0700
Message-ID: <20061109234009.GT16952@parisc-linux.org>
References: <200611081803.52986.wjl@icecavern.net> <4553BBB3.1000508@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:46776 "EHLO
	mail.parisc-linux.org") by vger.kernel.org with ESMTP
	id S1424266AbWKIXkK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Nov 2006 18:40:10 -0500
Content-Disposition: inline
In-Reply-To: <4553BBB3.1000508@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: "Wesley J. Landaker" <wjl@icecavern.net>, linux-scsi@vger.kernel.org, Carlos Pardo <Carlos.Pardo@siliconimage.com>

On Fri, Nov 10, 2006 at 08:37:23AM +0900, Tejun Heo wrote:
> >00:10.0 Mass storage controller [0180]: Silicon Image, Inc. Unknown device 
> >[1095:2502] (rev 01)
> >        Subsystem: Silicon Image, Inc. Unknown device [1095:2512]
> 
> SIMG says there's no such device and it's probably bad hardware 
> (probably a 3512) with stuck bits in PCI ID.  If you bought it, ask for 
> replacement.

It could also be a problem with his motherboard.  I'd try it in a
different slot (or in a different machine) before returning the card
as bad.
