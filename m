From: Rask Ingemann Lambertsen <rask@sygehus.dk>
Subject: Re: Using ncr53c8xx.c for a 53c770 chip
Date: Tue, 13 Jan 2004 15:15:03 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040113151503.B1738@sygehus.dk>
References: <20031122113834.GA8098@lst.de> <20031123175041.A1461@sygehus.dk> <1069606797.2066.2.camel@mulgrave> <20040113145553.A1738@sygehus.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 0x50a17253.albnxx15.adsl-dhcp.tele.dk ([80.161.114.83]:39428
	"EHLO 0x50a17253.albnxx15.adsl-dhcp.tele.dk") by vger.kernel.org
	with ESMTP id S264315AbUAMOPI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Jan 2004 09:15:08 -0500
Content-Disposition: inline
In-Reply-To: <20040113145553.A1738@sygehus.dk>; from rask@sygehus.dk on Tue, Jan 13, 2004 at 02:55:57PM +0100
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, Jan 13, 2004 at 02:55:57PM +0100, Rask Ingemann Lambertsen wrote:

> I need some help filling in the ncr_chip structure. Where do I find the
> device_id, revision_id, burst_max, nr_divisor and features settings? I can
> figure some of it out:
> .offset_max = 15 (the maximum allowed by the AmigaOS driver).
> .features = FE_ULTRA | FE_WIDE | FE_RAM (but maybe more flags are needed?)

I just got hold of the 53c770 programming guide, and it helps a lot with
this part, but comments are still welcome, of course.

-- 
Regards,
Rask Ingemann Lambertsen
