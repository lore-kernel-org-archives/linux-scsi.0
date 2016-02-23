From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH v3] mptbase: fixup error handling paths in mpt_attach()
Date: Tue, 23 Feb 2016 15:29:14 +0100
Message-ID: <20160223142914.GB7128@c203.arch.suse.de>
References: <1456236012-27300-1-git-send-email-emilne@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58747 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750936AbcBWO3S (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Feb 2016 09:29:18 -0500
Content-Disposition: inline
In-Reply-To: <1456236012-27300-1-git-send-email-emilne@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Ewan D. Milne" <emilne@redhat.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, wuninsu@gmail.com, thenzl@redhat.com, sreekanth.reddy@avagotech.com, MPT-FusionLinux.pdl@avagotech.com, taesoo@gatech.edu, yeongjin.jang@gatech.edu, insu@gatech.edu, changwoo@gatech.edu

On Tue, Feb 23, 2016 at 09:00:12AM -0500, Ewan D. Milne wrote:
> From: "Ewan D. Milne" <emilne@redhat.com>
>=20
> mpt_attach() was not checking for the failure to create fw_event_q.
> Also, iounmap() was not being called in all error cases after ioremap=
()
> had been called by mpt_mapresources().
>=20
> Reported-by: Insu Yun <wuninsu@gmail.com>
> Reviewed-by: Tomas Henzl <thenzl@redhat.com>
> Signed-off-by: Ewan D. Milne <emilne@redhat.com>

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
