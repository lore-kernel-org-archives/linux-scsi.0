From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 0/2] struct scsi_lun preparation
Date: Mon, 11 Sep 2006 15:55:40 -0400
Message-ID: <4505BF3C.8070806@garzik.org>
References: <20060911143406.GA12991@havoc.gtf.org> <1157995742.3470.10.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:47293 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S932278AbWIKTzn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Sep 2006 15:55:43 -0400
In-Reply-To: <1157995742.3470.10.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Mon, 2006-09-11 at 10:34 -0400, Jeff Garzik wrote:
>> A long-term, low priority project of mine is to increasingly isolate
>> HCIL addressing, making it easier to directly support FC/SAS-style
>> addressing without hacks and HCIL emulation.
> 
> I'm not sure we want to embed an actual struct scsi_lun into the whole
> of the scsi subsystem.  At the moment, given that no-one's actually
> managed to find any device that goes beyond two levels, the current u32
> for lun is perfectly fine.  If we're eventually forced beyond two
> levels, we can consider the transition (although going to u64 does look
> tempting).
> 
> A pretty print for the current u32 would be very useful though for
> transports dealing with non single level luns (or address methods other
> than zero).

A better subject line would have been "HCIL isolation" I suppose.  I 
would like to see increased usage of the accessors already present in 
include/scsi/scsi_device.h, which would ease the transition from 
hardcoded HCIL struct members to a more flexible addressing method.

Though, FWIW, for LUNs I would certainly like to see u64 rather than 
u32.....

	Jeff



