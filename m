From: Jesse Barnes <jbarnes@engr.sgi.com>
Subject: Re: SCSI QLA not working on latest *-mm SN2
Date: Tue, 21 Sep 2004 13:52:44 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200409211352.44235.jbarnes@engr.sgi.com>
References: <B179AE41C1147041AA1121F44614F0B0DD04DD@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx3-ext.sgi.com ([192.48.171.20]:32748 "EHLO omx3.sgi.com")
	by vger.kernel.org with ESMTP id S267745AbUIURxF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Sep 2004 13:53:05 -0400
In-Reply-To: <B179AE41C1147041AA1121F44614F0B0DD04DD@AVEXCH02.qlogic.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Matthew Wilcox <matthew@wil.cx>, James Bottomley <James.Bottomley@steeleye.com>, Grant Grundler <grundler@parisc-linux.org>, pj@sgi.com, SCSI Mailing List <linux-scsi@vger.kernel.org>, mdr@cthulhu.engr.sgi.com, jeremy@cthulhu.engr.sgi.com, djh@cthulhu.engr.sgi.com, Andrew Morton <akpm@osdl.org>

On Tuesday, September 21, 2004 1:33 pm, Andrew Vasquez wrote:
> Hmm...adding more confusion to the mix.  I apologize -- my reply was
> not written correctly, yes, the config-read will flush any pending
> writes.  But, the same problem persists -- the RISC will still stop
> responding to requests (config or MMIO) during the soft-reset --
> potentially resulting in a MAC (as seen by SGI).

Thanks for clarifying, I suspected that was the case.

> The 'safe' solution (as suggested by the hw people) was to use PIO to
> issue the soft-reset, then udelay().

But unfortunately, that doesn't get us 100% there, since even PIO space writes 
can be posted in some circumstances.  Any other suggestions?

Jesse
