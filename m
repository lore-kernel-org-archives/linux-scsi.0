From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH v2 1/5] bnx2fc: Add driver tunables.
Date: Thu, 07 Apr 2016 15:57:44 +0200
Message-ID: <2724497.X4WySxZgTk@c203>
References: <1460034480-28512-1-git-send-email-chad.dupuis@qlogic.com> <1460034480-28512-2-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53229 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750993AbcDGN5q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Apr 2016 09:57:46 -0400
In-Reply-To: <1460034480-28512-2-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chad Dupuis <chad.dupuis@qlogic.com>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, saurav.kashyap@qlogic.com, linux-scsi@vger.kernel.org

On Donnerstag, 7. April 2016 09:07:56 CEST Chad Dupuis wrote:
> From: Joe Carnuccio <joe.carnuccio@qlogic.com>
>=20
> Per customer request, add the following driver tunables:
>=20
> o devloss_tmo
> o max_luns
> o queue_depth
> o tm_timeout
>=20
> tm_timeout is set per scsi_host in /sys/class/scsi_host/hostX/tm_time=
out.
>=20
> Signed-off-by: Joe Carnuccio <joe.carnuccio@qlogic.com>
> Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
> ---

Looks good to me,
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
