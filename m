From: christian.suenkenberg@hfg-karlsruhe.de
Subject: Re: [PATCH] scsi: Add Intel Multi-Flex to scsi scan blacklist
Date: Thu, 20 Nov 2014 12:10:58 +0100
Message-ID: <20141120121058.Horde.TOmtlQZW4WfH4rWoXm9iVg3@webmail.hfg-karlsruhe.de>
References: <1416338612.13492.17.camel@hfg-karlsruhe.de>
 <20141120064606.GB5928@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed	DelSp=Yes
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0.hfg-karlsruhe.de ([193.197.160.26]:40505 "EHLO
	mx0.hfg-karlsruhe.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792AbaKTLLA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Nov 2014 06:11:00 -0500
In-Reply-To: <20141120064606.GB5928@infradead.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

Hello,

On Wed, 19 Nov 2014 22:46:06 -0800, Christoph Hellwig wrote:
> Looks reasonable.  Btw, that is the Intel Multi-Flex? A search seems =
to
> b pointing to ethernet switches..

it's a volume manager / multiplexer that comes with the Intel Modular
Server Chassis (MFSYS25 / MFSYS35 / MFSYS25V2). It allows you to create
RAID volumes on a shared storage controller and attach them to up to
six compute blades. Compute blades then see the volumes as LUs of an
Intel Multi-Flex device attached to their LSI SAS 1064E.

I'd also like to ask whether this patch could land in stable,
as one needs a very patient initramfs or rootdelay at the moment
to boot distributions post Linux 3.6 on these machines.

Regards,
Christian S=C3=BCnkenberg

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
