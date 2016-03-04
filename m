From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] be2iscsi: set the boot_kset pointer to NULL in case of
 failure
Date: Fri, 4 Mar 2016 12:36:29 +0100
Message-ID: <20160304113629.GA23077@c203.arch.suse.de>
References: <1457084509-7368-1-git-send-email-mlombard@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45862 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750915AbcCDLgk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Mar 2016 06:36:40 -0500
Content-Disposition: inline
In-Reply-To: <1457084509-7368-1-git-send-email-mlombard@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Maurizio Lombardi <mlombard@redhat.com>
Cc: jayamohan.kallickal@avagotech.com, ketan.mukadam@avagotech.com, sony.john@avagotech.com, linux-scsi@vger.kernel.org

On Fri, Mar 04, 2016 at 10:41:49AM +0100, Maurizio Lombardi wrote:
> In beiscsi_setup_boot_info(), the boot_kset pointer should be set
> to NULL in case of failure otherwise an invalid pointer dereference
> may occur later.
>=20
> Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

Btw, should this go to stable as well?
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
