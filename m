From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2] scsi: Export SCSI Inquiry data to sysfs
Date: Wed, 21 Oct 2015 08:32:15 +0200
Message-ID: <5627316F.9090706@suse.de>
References: <1439537960-25085-1-git-send-email-jthumshirn@suse.de> <mqdh9mjyijh.fsf@c203.arch.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <mqdh9mjyijh.fsf@c203.arch.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, James Smart <james.smart@avagotech.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "James E.J. Bottomley" <JBottomley@odin.com>
List-Id: linux-scsi@vger.kernel.org

On 09/24/2015 04:54 PM, Johannes Thumshirn wrote:
>=20
> Ping?
>=20
I really would like to see them included, as with this we can move
the udev rules over to not issuing any SG_IO commands during event
processing. This helps a lot for multipath failover scenarios.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
