From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PATCH v2] scsi/fcoe: convert to kworker
Date: Mon, 4 Jul 2016 10:23:46 +0200
Message-ID: <205de315-192e-cf72-7163-5e2d8175a74f@linutronix.de>
References: <1457710143-29182-1-git-send-email-bigeasy@linutronix.de>
 <1457710143-29182-2-git-send-email-bigeasy@linutronix.de>
 <20160311161704.GA5083@infradead.org> <56E2F30F.5030108@linutronix.de>
 <20160315081940.GB9136@infradead.org> <20160412151654.GB20685@linutronix.de>
 <20160610103812.ojgzop6qdv3mos5d@c203.arch.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from www.linutronix.de ([62.245.132.108]:57274 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895AbcGDIYB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jul 2016 04:24:01 -0400
In-Reply-To: <20160610103812.ojgzop6qdv3mos5d@c203.arch.suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, rt@linutronix.de, Vasu Dev <vasu.dev@intel.com>, fcoe-devel@open-fcoe.org

On 06/10/2016 12:38 PM, Johannes Thumshirn wrote:
=E2=80=A6

>=20
> Tested in a Boot from FCoE scenario using a BCM57840.

This got merged over the weekend. Thanks for that. I will try to look
into the other two (bnx2i, bnx2fc) and convert them as well within this
week.

Sebastian
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
