From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 0/2] arcmsr: support areca new adapter ARC1203
Date: Tue, 24 Nov 2015 16:07:15 +0100
Message-ID: <56547D23.1010100@suse.de>
References: <1448352055.12861.39.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1448352055.12861.39.camel@Centos6.3-64>
Sender: linux-kernel-owner@vger.kernel.org
To: Ching Huang <ching2048@areca.com.tw>, hch@infradead.org, thenzl@redhat.com, jbottomley@parallels.com, dan.carpenter@oracle.com, agordeev@redhat.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: hch@lst.de
List-Id: linux-scsi@vger.kernel.org

On 11/24/2015 09:00 AM, Ching Huang wrote:
> From: Ching Huang <ching2048@areca.com.tw>
>=20
> Patch 1 fixes getting wrong configuration data.
>=20
> Pacth 2 adds codes to support new adapter ARC1203.
>=20
Please split off the driver version update into a separate patch and
add it as the last patch in the series.
Otherwise it'll be hard to keep track of which patch belongs to
which version.

Thanks.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
