From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PATCH 1/4] scsi: bnx2fc: convert per-CPU thread to kworker
Date: Wed, 20 Jul 2016 14:07:19 +0200
Message-ID: <323040c8-3b63-7e49-a492-e071610459fd@linutronix.de>
References: <1467734929-24442-1-git-send-email-bigeasy@linutronix.de>
 <20160720110421.5ocuquyqki2uggg4@c203.arch.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:58848 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753548AbcGTMHc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Jul 2016 08:07:32 -0400
In-Reply-To: <20160720110421.5ocuquyqki2uggg4@c203.arch.suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: linux-scsi@vger.kernel.org, jth@kernel.org, rt@linutronix.de, jejb@linux.vnet.ibm.com, "Martin K . Petersen" <martin.petersen@oracle.com>, QLogic-Storage-Upstream@qlogic.com, Christoph Hellwig <hch@lst.de>

On 07/20/2016 01:04 PM, Johannes Thumshirn wrote:
> Hi Sebastian,

Hi Johannes,

> I've tried to test your series and unfortunately I encountered the fo=
llowing
> oops.
thanks for testing.
=85
>=20
> I'll try to narrow it down to the specific patch, but currently I'm a=
 bit
> busy, sorry.

I looked over the patch and noticed nothing. It was possible to run the
worker but somehow the spinlock exploded.

>=20
> Johannes
>=20
Sebastian
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
