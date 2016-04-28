From: Johannes Thumshirn <jthmshirn@suse.de>
Subject: Re: [PATCH 1/7] hpsa: correct initialization order issue
Date: Thu, 28 Apr 2016 09:50:48 +0200
Message-ID: <20160428075048.GN2820@c203.arch.suse.de>
References: <146179474454.31195.15135625511559409075.stgit@brunhilda>
 <146179520607.31195.18171570890226870133.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55874 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750845AbcD1Huv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Apr 2016 03:50:51 -0400
Content-Disposition: inline
In-Reply-To: <146179520607.31195.18171570890226870133.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@microsemi.com>
Cc: jejb@linux.vnet.ibm.com, Viswas.G@microsemi.com, Mahesh.Rajashekhara@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Kevin.Barnett@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, elliott@hpe.com, linux-scsi@vger.kernel.org

On Wed, Apr 27, 2016 at 05:13:26PM -0500, Don Brace wrote:
> The driver was calling scsi_scan_host before enabling interrupts.
>=20
> This has gone unnoticed except for customers running in intx mode.
> Calling scsi_scan_host before interrupts are enabled causes
> "irq XX: nobody cared" messages and the driver to hang.
>=20
> This patch enables interrupts before the call to scsi_scan_host.
>=20
> Reported-by: Piotr Karbowski <piotr.karbowski@gmail.com>
> Reviewed-by: Scott Teel <scott.teel@microsemi.com>
> Reviewed-by: Kevin Barnett <kevin.barnett@microsemi.com>
> Signed-off-by: Don Brace <don.brace@microsemi.com>

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

--=20
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
