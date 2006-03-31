From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Compaq Fiber Channel Array RM4000 / 2.6.16 kernel patch VER6
Date: Fri, 31 Mar 2006 15:21:40 -0600
Message-ID: <1143840100.3342.57.camel@mulgrave.il.steeleye.com>
References: <1143656547.3248.36.camel@mulgrave.il.steeleye.com>
	 <Pine.GSO.4.64.0603292025500.4009@filebunker.xip.at>
	 <1143657838.3248.39.camel@mulgrave.il.steeleye.com>
	 <Pine.GSO.4.64.0603292052430.4009@filebunker.xip.at>
	 <1143659029.3248.42.camel@mulgrave.il.steeleye.com>
	 <Pine.GSO.4.64.0603292125370.4009@filebunker.xip.at>
	 <1143666681.3248.48.camel@mulgrave.il.steeleye.com>
	 <Pine.GSO.4.64.0603301252100.595@filebunker.xip.at>
	 <20060330125816.GG13590@parisc-linux.org>
	 <Pine.GSO.4.64.0603301523130.6412@filebunker.xip.at>
	 <20060330162429.GI13590@parisc-linux.org>
	 <Pine.GSO.4.64.0603301825560.14161@filebunker.xip.at>
	 <1143834313.3342.54.camel@mulgrave.il.steeleye.com>
	 <Pine.GSO.4.64.0603312311590.25350@filebunker.xip.at>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:37855 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1750720AbWCaVVs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 31 Mar 2006 16:21:48 -0500
In-Reply-To: <Pine.GSO.4.64.0603312311590.25350@filebunker.xip.at>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ingo Flaschberger <if@xip.at>
Cc: Matthew Wilcox <matthew@wil.cx>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, 2006-03-31 at 23:13 +0200, Ingo Flaschberger wrote:
> Here, but only for the RA4x00.

That's the read/write command conversion.  There doesn't seem to be
anywhere the limit is communicated to the block layer.

James


