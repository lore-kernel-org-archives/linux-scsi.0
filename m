From: David Miller <davem@davemloft.net>
Subject: Re: SAVE_DATA / RESTORE_POINTERS message confusion
Date: Sun, 29 Apr 2007 14:37:59 -0700 (PDT)
Message-ID: <20070429.143759.71876461.davem@davemloft.net>
References: <Pine.LNX.4.60.0704292249200.4454@poirot.grange>
	<1177881499.3688.82.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46406
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1161461AbXD2ViD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 29 Apr 2007 17:38:03 -0400
In-Reply-To: <1177881499.3688.82.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: g.liakhovetski@gmx.de, linux-scsi@vger.kernel.org

From: James Bottomley <James.Bottomley@SteelEye.com>
Date: Sun, 29 Apr 2007 16:18:19 -0500

> On Sun, 2007-04-29 at 22:56 +0200, Guennadi Liakhovetski wrote:
> > 2. are they ever sent apart from when accompanying the DISCONNECT / 
> > RESELECT?
> 
> I've never seen an occasion, no.

I have.

> > 3. if "yes" to 2 - can the RESTORE be used to "rewind" the pointer to a 
> > value smaller than the current?
> 
> Theoretically, yes.  In practice, no device I've ever heard of has done
> this.

I've seen a device do this, and ironically for an inquiry :-)

This device also spit out an IGNORE_WIDE_RESIDUE as well.

In fact, a lot of devices do really strange things for tagged non-I/O
commands such as INQUIRY.
