From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Compaq Fiber Channel Array RM4000 / 2.6.16 kernel patch
Date: Thu, 30 Mar 2006 09:09:28 -0600
Message-ID: <1143731368.3328.3.camel@mulgrave.il.steeleye.com>
References: <1143653396.3248.34.camel@mulgrave.il.steeleye.com>
	 <Pine.GSO.4.64.0603291949370.4009@filebunker.xip.at>
	 <1143656547.3248.36.camel@mulgrave.il.steeleye.com>
	 <Pine.GSO.4.64.0603292025500.4009@filebunker.xip.at>
	 <1143657838.3248.39.camel@mulgrave.il.steeleye.com>
	 <Pine.GSO.4.64.0603292052430.4009@filebunker.xip.at>
	 <1143659029.3248.42.camel@mulgrave.il.steeleye.com>
	 <Pine.GSO.4.64.0603292125370.4009@filebunker.xip.at>
	 <1143666681.3248.48.camel@mulgrave.il.steeleye.com>
	 <Pine.GSO.4.64.0603301252100.595@filebunker.xip.at>
	 <20060330125816.GG13590@parisc-linux.org>
	 <Pine.GSO.4.64.0603301523130.6412@filebunker.xip.at>
	 <1143729995.3328.1.camel@mulgrave.il.steeleye.com>
	 <Pine.GSO.4.64.0603301657170.6412@filebunker.xip.at>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:30094 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1750783AbWC3PJe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Mar 2006 10:09:34 -0500
In-Reply-To: <Pine.GSO.4.64.0603301657170.6412@filebunker.xip.at>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ingo Flaschberger <if@xip.at>
Cc: Matthew Wilcox <matthew@wil.cx>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, 2006-03-30 at 17:04 +0200, Ingo Flaschberger wrote:
> Ans thats was why I used the BLIST_REPORTLUN0 before, because using 
> BLIST_REPORTLUN2 (try REPORT_LUNS even for SCSI-2 devs) is not very 
> "logic" for SCSI_UNKNOWN devices...
> 
> I suggest to rename BLIST_REPORTLUN2 to BLIST_REPORTLUN?

Possibly, but in a separate patch, please.

James


