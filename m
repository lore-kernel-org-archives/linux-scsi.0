From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Compaq Fiber Channel Array RM4000 / 2.6.16 kernel patch
Date: Wed, 29 Mar 2006 12:22:27 -0600
Message-ID: <1143656547.3248.36.camel@mulgrave.il.steeleye.com>
References: <20060228004043.GH27759@parisc-linux.org>
	 <Pine.GSO.4.64.0603221911370.14214@filebunker.xip.at>
	 <yq1lkv2iap8.fsf@wilson.lab.mkp.net>
	 <Pine.GSO.4.64.0603222054520.14214@filebunker.xip.at>
	 <20060322200229.GT8980@parisc-linux.org>
	 <Pine.GSO.4.64.0603222105560.14214@filebunker.xip.at>
	 <Pine.GSO.4.64.0603282134370.8439@filebunker.xip.at>
	 <yq18xqtain6.fsf@wilson.lab.mkp.net>
	 <Pine.GSO.4.64.0603291305590.4009@filebunker.xip.at>
	 <Pine.GSO.4.64.0603291428590.4009@filebunker.xip.at>
	 <20060329150729.GA14690@infradead.org>
	 <Pine.GSO.4.64.0603291845550.4009@filebunker.xip.at>
	 <1143653396.3248.34.camel@mulgrave.il.steeleye.com>
	 <Pine.GSO.4.64.0603291949370.4009@filebunker.xip.at>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:23236 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1750921AbWC2SWa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Mar 2006 13:22:30 -0500
In-Reply-To: <Pine.GSO.4.64.0603291949370.4009@filebunker.xip.at>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ingo Flaschberger <if@xip.at>
Cc: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, 2006-03-29 at 19:53 +0200, Ingo Flaschberger wrote:
> > Really no to this we're trying to get away from changing actual reported
> > device information.  I assume the device reports SCSI-3
> 
> The device reports "zero" and thats why I need to force SCSI2!
> Its better to force SCSI2 in one position than to deal with "SCSI_UNKNOWN" 
> in severall position?

Why?  We're actually trying to make SCSI_UNKNOWN work for some sbp2 and
USB storage as well.  What specific problems does it cause?

James


