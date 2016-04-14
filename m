From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv2 09/14] libata: fixup ZAC device disabling
Date: Thu, 14 Apr 2016 07:48:03 +0200
Message-ID: <570F2F13.2040509@suse.de>
References: <1460443678-57934-1-git-send-email-hare@suse.de>
 <1460443678-57934-10-git-send-email-hare@suse.de>
 <20160413180947.GF3676@htj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46149 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752327AbcDNFsF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Apr 2016 01:48:05 -0400
In-Reply-To: <20160413180947.GF3676@htj.duckdns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-ide@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Shaun Tancheff <shaun.tancheff@seagate.com>, Damien Le Moal <damien.lemoal@hgst.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On 04/13/2016 08:09 PM, Tejun Heo wrote:
> On Tue, Apr 12, 2016 at 08:47:53AM +0200, Hannes Reinecke wrote:
>> libata device disabling is ... curious. So add the correct
>> definitions that we can disable ZAC devices properly.
>=20
> Fold into an earlier patch?
>=20
That earlier patch would be commit
9162c6579bf90b3f5ddb7e3a6c6fa946c1b4cbeb
("libata: Implement ATA_DEV_ZAC"), which got merged
in 2014 ...

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
