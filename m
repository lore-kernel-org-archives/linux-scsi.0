From: Sven Rudolph <Sven_Rudolph@drewag.de>
Subject: Re: Atto UL5D: negotiates only up to FAST-40 SCSI
Date: Fri, 17 Nov 2006 18:22:07 +0100
Message-ID: <xfkhcwy6la8.fsf@uxrs53.drewag.de>
References: <xfku00y8gjn.fsf@uxrs53.drewag.de>
	<1163777478.8594.18.camel@mulgrave.il.steeleye.com>
	<xfk8xia82tn.fsf@uxrs53.drewag.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from miranda.drewag.de ([212.111.238.29]:9098 "EHLO
	miranda.drewag.de") by vger.kernel.org with ESMTP id S1755758AbWKQRVv
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Nov 2006 12:21:51 -0500
In-Reply-To: <xfk8xia82tn.fsf@uxrs53.drewag.de> (Sven Rudolph's message of
 "Fri, 17 Nov 2006 17:17:56 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sven Rudolph <Sven_Rudolph@drewag.de>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org

Sven Rudolph <Sven_Rudolph@drewag.de> writes:

> FAST-160 is detected when the same cable, storage cage and disk drive
> are connected to the LSI controller, but on the Atto only FAST-40
> appears. Does it make sense to try another SCSI cable?

Something I forgot to mention: I became aware of the problem when I
tried to read from (or write to (?)) three disks in parallel and the
sum of the transfer speeds was a bit below 40 MBytes/second when I ran
two disks and it was the nearly the same with three disks. The first
disk was the fastest in the three-disk test run, and the third was the
slowest. I suppose this is due to SCSI priority by SCSI ID. So I'm
quite sure that the bus really only runs in FAST-40 mode.

	Sven

