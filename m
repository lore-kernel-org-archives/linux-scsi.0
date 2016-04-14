From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv2 06/14] libata: Check log page directory before accessing
 pages
Date: Thu, 14 Apr 2016 07:44:39 +0200
Message-ID: <570F2E47.2040501@suse.de>
References: <1460443678-57934-1-git-send-email-hare@suse.de>
 <1460443678-57934-7-git-send-email-hare@suse.de>
 <20160413180835.GE3676@htj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20160413180835.GE3676@htj.duckdns.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-ide@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Shaun Tancheff <shaun.tancheff@seagate.com>, Damien Le Moal <damien.lemoal@hgst.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>
List-Id: linux-scsi@vger.kernel.org

On 04/13/2016 08:08 PM, Tejun Heo wrote:
> On Tue, Apr 12, 2016 at 08:47:50AM +0200, Hannes Reinecke wrote:
>> +	log_pages =3D get_unaligned_le16(&ap->sector_buf[log_index]);
>> +	if (!log_pages) {
>> +		ata_dev_warn(dev,
>> +			     "NCQ Send/Recv Log not supported\n");
>=20
> Shouldn't this be an info message?
>=20
Sure. Will be adjusting it.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
