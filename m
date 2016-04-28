From: Johannes Thumshirn <jthmshirn@suse.de>
Subject: Re: [PATCH 5/7] hpsa: correct ioaccel2 error procecssing.
Date: Thu, 28 Apr 2016 09:58:09 +0200
Message-ID: <20160428075809.GR2820@c203.arch.suse.de>
References: <146179474454.31195.15135625511559409075.stgit@brunhilda>
 <146179524703.31195.9154842043010596458.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56543 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751514AbcD1H6M (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Apr 2016 03:58:12 -0400
Content-Disposition: inline
In-Reply-To: <146179524703.31195.9154842043010596458.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@microsemi.com>
Cc: jejb@linux.vnet.ibm.com, Viswas.G@microsemi.com, Mahesh.Rajashekhara@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Kevin.Barnett@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, elliott@hpe.com, linux-scsi@vger.kernel.org

On Wed, Apr 27, 2016 at 05:14:07PM -0500, Don Brace wrote:
> set offload_to_be_enabled to 0 when an ioaccel2 error is processed.
>=20
> Before, an ioaccel completion error would turn of ioaccel but a resca=
n
> would turn it back on again.
>=20
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
