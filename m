From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] nvme-fabrics: Patch host code in prep for FC transport
 support
Date: Mon, 25 Jul 2016 10:44:24 +0200
Message-ID: <20160725084424.iik47jb647zjq465@c203.arch.suse.de>
References: <5792b916.P2ksarpXpcxZ+l9s%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57867 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752475AbcGYIo0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Jul 2016 04:44:26 -0400
Content-Disposition: inline
In-Reply-To: <5792b916.P2ksarpXpcxZ+l9s%james.smart@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@broadcom.com>
Cc: linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org

On Fri, Jul 22, 2016 at 05:23:50PM -0700, James Smart wrote:
>=20
> Patch nvme-fabrics host code in prep for FC transport support:
> - Add the host_traddr field to allow specification of the host-port
>   connection info for the transport. Will be used by FC transport.
> - Revise nvmf_get_address() string to account for not all options bei=
ng
>   present.
> - Revise some of the comments so not so ethernet-network centric

This IMHO should at least be split into two patches, one for:

 - Add the host_traddr field to allow specification of the host-port
   connection info for the transport. Will be used by FC transport.

and one for:

 - Revise nvmf_get_address() string to account for not all options bein=
g
   present.

I'm not sure if the comment change needs to be split out or can be part=
 of
one of these patches or should be split out.

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
