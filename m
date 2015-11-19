From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 00/18] ALUA device handler update, part 1
Date: Thu, 19 Nov 2015 10:42:02 +0100
Message-ID: <564D996A.9080201@suse.de>
References: <1447081703-110552-1-git-send-email-hare@suse.de> <20151119083541.GA27623@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37796 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755978AbbKSJmE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Nov 2015 04:42:04 -0500
In-Reply-To: <20151119083541.GA27623@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Jamed Bottomley <jbottomley@odin.com>, linux-scsi@vger.kernel.org, Johannes Thumshirn <jthumshirn@suse.com>, Ewan Milne <emilne@redhat.com>

On 11/19/2015 09:35 AM, Christoph Hellwig wrote:
> Can you push out a git branch with this code for easier review as wel=
l?
>=20
Pushed to kernel.org:hare/scsi-devel.git branch alua.v6
Branch is based upon mkp/scsi.git branch 4.5/scsi-queue

Thanks for reviewing.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
