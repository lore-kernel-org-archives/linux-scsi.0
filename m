From: Ingo Flaschberger <if@xip.at>
Subject: Re: Compaq Fiber Channel Array RM4000 / 2.6.16 kernel patch
Date: Wed, 29 Mar 2006 20:54:29 +0200 (CEST)
Message-ID: <Pine.GSO.4.64.0603292052430.4009@filebunker.xip.at>
References: <20060228004043.GH27759@parisc-linux.org>
 <Pine.GSO.4.64.0603221911370.14214@filebunker.xip.at>  <yq1lkv2iap8.fsf@wilson.lab.mkp.net>
  <Pine.GSO.4.64.0603222054520.14214@filebunker.xip.at>
 <20060322200229.GT8980@parisc-linux.org>  <Pine.GSO.4.64.0603222105560.14214@filebunker.xip.at>
  <Pine.GSO.4.64.0603282134370.8439@filebunker.xip.at>  <yq18xqtain6.fsf@wilson.lab.mkp.net>
  <Pine.GSO.4.64.0603291305590.4009@filebunker.xip.at>
 <Pine.GSO.4.64.0603291428590.4009@filebunker.xip.at>  <20060329150729.GA14690@infradead.org>
  <Pine.GSO.4.64.0603291845550.4009@filebunker.xip.at>
 <1143653396.3248.34.camel@mulgrave.il.steeleye.com>
 <Pine.GSO.4.64.0603291949370.4009@filebunker.xip.at>
 <1143656547.3248.36.camel@mulgrave.il.steeleye.com>
 <Pine.GSO.4.64.0603292025500.4009@filebunker.xip.at>
 <1143657838.3248.39.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1.xip.at ([193.239.188.99]:63908 "EHLO chile.gbit.at")
	by vger.kernel.org with ESMTP id S1750705AbWC2Sya (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Mar 2006 13:54:30 -0500
In-Reply-To: <1143657838.3248.39.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

Hello James,


> On Wed, 2006-03-29 at 20:35 +0200, Ingo Flaschberger wrote:
>> scsi_report_lun_scan:
>>          if ((bflags & BLIST_NOREPORTLUN) ||
>>               starget->scsi_level < SCSI_2 ||
>>              (starget->scsi_level < SCSI_3 &&
>>               (!(bflags & BLIST_REPORTLUN2) || shost->max_lun <= 8)) )
>>                  return 1;
>
> Doesn't SCSI_UNKNOWN satisfy the starget->scsi_level < SCSI_2, so the
> additional NOREPORTLUN should be unnecessary?

Aeh....
I need to avoid the return 1; and go on in the function.....

Kind regards,
 	Ingo
