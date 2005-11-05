From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 12/25] scsi: move SG_IO ioctl32 code to sg.c
Date: Sat, 5 Nov 2005 20:19:58 +0100
Message-ID: <200511052020.00751.arnd@arndb.de>
References: <20051105162650.620266000@b551138y.boeblingen.de.ibm.com> <20051105162715.367344000@b551138y.boeblingen.de.ibm.com> <1131209099.3614.7.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932301AbVKETSh@vger.kernel.org>
In-Reply-To: <1131209099.3614.7.camel@mulgrave>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, dgilbert@interlog.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On S=FCnnavend 05 November 2005 17:44, James Bottomley wrote:
> This is the wrong place, isn't it? =A0SG_IO is also in
> drivers/block/scsi_ioctl.c which isn't modular, so shouldn't this be =
in
> there?
>=20

Yes, you're right. That patch broke compat SG_IO for the other scsi
drivers. I'll do a new one.

	Arnd <><
