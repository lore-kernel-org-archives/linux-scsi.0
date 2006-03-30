From: Ingo Flaschberger <if@xip.at>
Subject: Re: Compaq Fiber Channel Array RM4000 / 2.6.16 kernel patch
Date: Thu, 30 Mar 2006 17:04:06 +0200 (CEST)
Message-ID: <Pine.GSO.4.64.0603301657170.6412@filebunker.xip.at>
References: <1143653396.3248.34.camel@mulgrave.il.steeleye.com>
 <Pine.GSO.4.64.0603291949370.4009@filebunker.xip.at>
 <1143656547.3248.36.camel@mulgrave.il.steeleye.com>
 <Pine.GSO.4.64.0603292025500.4009@filebunker.xip.at>
 <1143657838.3248.39.camel@mulgrave.il.steeleye.com>
 <Pine.GSO.4.64.0603292052430.4009@filebunker.xip.at>
 <1143659029.3248.42.camel@mulgrave.il.steeleye.com>
 <Pine.GSO.4.64.0603292125370.4009@filebunker.xip.at>
 <1143666681.3248.48.camel@mulgrave.il.steeleye.com>
 <Pine.GSO.4.64.0603301252100.595@filebunker.xip.at>  <20060330125816.GG13590@parisc-linux.org>
  <Pine.GSO.4.64.0603301523130.6412@filebunker.xip.at>
 <1143729995.3328.1.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1.xip.at ([193.239.188.99]:37799 "EHLO chile.gbit.at")
	by vger.kernel.org with ESMTP id S1750769AbWC3PEH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Mar 2006 10:04:07 -0500
In-Reply-To: <1143729995.3328.1.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

Hello James,

> Actually, this one's still not quite right.  The default for
> SCSI_UNKNOWN needs to be not to do a report lun scan *unless*
> BLIST_REPORTLUN2 is set ... that way we won't disrupt the functioning of
> current SCSI_UNKNOWN devices (i.e. just drop the last SCSI_UNKNOWN check
> and add BLIST_REPORTLUNS2 to the flags of the compaq array type).

Ans thats was why I used the BLIST_REPORTLUN0 before, because using 
BLIST_REPORTLUN2 (try REPORT_LUNS even for SCSI-2 devs) is not very 
"logic" for SCSI_UNKNOWN devices...

I suggest to rename BLIST_REPORTLUN2 to BLIST_REPORTLUN?

bye,
 	Ingo
