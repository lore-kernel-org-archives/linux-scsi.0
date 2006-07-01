From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: Re: [GIT PATCH] final SCSI updates for 2.6.17
Date: Fri, 30 Jun 2006 21:17:33 -0600
Message-ID: <003201c69cbc$ed640e60$241015ac@ericmoore>
References: <1151723367.8921.68.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:58295 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1751442AbWGADRa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Jun 2006 23:17:30 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Friday, June 30, 2006 9:09 PM, James Bottomley wrote:


> This is the final 2.6.17 scsi updates.  It contains the port API for SAS
> that we held off on; quite a slew of driver updates and some
> miscellaneous bug fixes.
> 

I noticed you didn't pick up the mptsas patch for zero base port ids.
Is that because your eventually going to have transport do
the port id assignments?

Eric

