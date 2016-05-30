From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] bnx2fc: replace printk() with BNX2FC_IO_DBG()
Date: Mon, 30 May 2016 10:53:49 +0200
Message-ID: <20160530085349.dbwo4unvlx5hb32s@c203.arch.suse.de>
References: <1464597661-6192-1-git-send-email-mlombard@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42517 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932253AbcE3Ixv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 May 2016 04:53:51 -0400
Content-Disposition: inline
In-Reply-To: <1464597661-6192-1-git-send-email-mlombard@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Maurizio Lombardi <mlombard@redhat.com>
Cc: axboe@kernel.dk, QLogic-Storage-Upstream@qlogic.com, linux-scsi@vger.kernel.org, loberman@redhat.com

On Mon, May 30, 2016 at 10:41:01AM +0200, Maurizio Lombardi wrote:
> The "fcp_rsp_code =3D %d" message isn't an error, it's meant to
> be informative only.
> This patch prevents a flood of such messages in some situations.
>=20
> Tested-by: Laurence Oberman <loberman@redhat.com>
> Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>

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
