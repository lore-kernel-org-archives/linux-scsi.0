From: "Eric Moore" <emoore@lsil.com>
Subject: Re: Why is the kernel complaining about large SCSI LUNs
Date: Fri, 7 Jan 2005 09:16:14 -0700
Message-ID: <008001c4f4d4$364d0d80$111015ac@ericmoore>
References: <a06100533be0463eff562@[129.98.90.227]>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:32168 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S261486AbVAGQP1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Jan 2005 11:15:27 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Maurice Volaski <mvolaski@aecom.yu.edu>

The mpt fusion driver supports 256 luns, 
and it seems your device supports more than that.

Eric

On Friday, January 07, 2005 9:07 AM, Maurice Volaski wrote:

> I am running kernel 2.6.9 on an Opteron box with an LSI 320 card and 
> am seeing the following message repeatedly in dmesg:
> 
> scsi: host 1 channel 0 id 0 lun 0x5a5a5a5a5a5a5a5a has a LUN larger 
> than currently supported.
> 
> Is this just cosmetic or there is a bug somewhere? It appears that 
> scsi_scan.c has logic where this message is actually valid, but how 
> can that be?
> -- 
> 
> Maurice Volaski, mvolaski@aecom.yu.edu
> Computing Support, Rose F. Kennedy Center
> Albert Einstein College of Medicine of Yeshiva University
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

