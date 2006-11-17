From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Atto UL5D: negotiates only up to FAST-40 SCSI
Date: Fri, 17 Nov 2006 09:31:18 -0600
Message-ID: <1163777478.8594.18.camel@mulgrave.il.steeleye.com>
References: <xfku00y8gjn.fsf@uxrs53.drewag.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:54471 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1755714AbWKQPbY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Nov 2006 10:31:24 -0500
In-Reply-To: <xfku00y8gjn.fsf@uxrs53.drewag.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sven Rudolph <Sven_Rudolph@drewag.de>
Cc: linux-scsi@vger.kernel.org

On Fri, 2006-11-17 at 12:21 +0100, Sven Rudolph wrote:
>   scsi 1:0:3:0: Direct-Access     SEAGATE  ST3300007LC      7806 PQ: 0
> ANSI: 3
>    target1:0:3: Beginning Domain Validation
>    target1:0:3: Domain Validation skipping write tests
>    target1:0:3: Ending Domain Validation
>    target1:0:3: FAST-40 SCSI 40.0 MB/s ST (25 ns, offset 63)

This is characteristic of the bus being in single ended mode, can you
execute

cat /sys/class/spi_host/host1/signalling

and see what it says.  If it returns SE, that's your problem.

>   scsi 1:0:8:0: Processor         QLogic   GEM359           1.10 PQ: 0
> ANSI: 2

This is a very old (circa 2000) processor.  Are you sure your storage
cage supports LVD?

James


