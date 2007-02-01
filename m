From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] - export scsilun_to_int
Date: Thu, 01 Feb 2007 12:35:12 -0500
Message-ID: <45C224D0.7080407@garzik.org>
References: <20070201172442.GA8322@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:41297 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422747AbXBARfQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Feb 2007 12:35:16 -0500
In-Reply-To: <20070201172442.GA8322@lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric Moore <eric.moore@lsi.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

Eric Moore wrote:
> On Wednesday, January 31, 2007 6:52 PM, James Bottomley wrote:
>> what's wrong with
>>
>> memcmp(lun1->scsi_lun, lun2->scsi_lun, 8)
>>
>> rather than introducing a wrapper?  The compiler can even optimise
>> memcmp for a fixed size nicely.
>>
>> James
>>
> 
> 
> Changed to using memcmp. This replaces the prevous patch.
> 
> 
> Signed-off-by: Eric Moore <Eric.Moore@lsi.com>

IMO a wrapper is better.

memcmp() is not type-safe nor type-aware, and we have already created a 
type for SCSI LUNs.

	Jeff



