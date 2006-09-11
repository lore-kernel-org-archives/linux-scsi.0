From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 0/2] struct scsi_lun preparation
Date: Mon, 11 Sep 2006 12:29:02 -0500
Message-ID: <1157995742.3470.10.camel@mulgrave.il.steeleye.com>
References: <20060911143406.GA12991@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:10952 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751274AbWIKR3Y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Sep 2006 13:29:24 -0400
In-Reply-To: <20060911143406.GA12991@havoc.gtf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-scsi@vger.kernel.org

On Mon, 2006-09-11 at 10:34 -0400, Jeff Garzik wrote:
> A long-term, low priority project of mine is to increasingly isolate
> HCIL addressing, making it easier to directly support FC/SAS-style
> addressing without hacks and HCIL emulation.

I'm not sure we want to embed an actual struct scsi_lun into the whole
of the scsi subsystem.  At the moment, given that no-one's actually
managed to find any device that goes beyond two levels, the current u32
for lun is perfectly fine.  If we're eventually forced beyond two
levels, we can consider the transition (although going to u64 does look
tempting).

A pretty print for the current u32 would be very useful though for
transports dealing with non single level luns (or address methods other
than zero).

James


