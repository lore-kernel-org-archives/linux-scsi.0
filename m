From: Hannes Reinecke <hare@suse.de>
Subject: Re: [dm-devel] [PATCH] scsi : Adding all the definitions of host
 bytes in hostbyte_table
Date: Mon, 30 Jul 2012 08:15:50 +0200
Message-ID: <50162696.50105@suse.de>
References: <77471C95FAFD844C8CA02DD4F4C5FE2B0BC9EDE3@SACEXCMBX02-PRD.hq.netapp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48787 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751385Ab2G3GPw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Jul 2012 02:15:52 -0400
In-Reply-To: <77471C95FAFD844C8CA02DD4F4C5FE2B0BC9EDE3@SACEXCMBX02-PRD.hq.netapp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: "Moger, Babu" <Babu.Moger@netapp.com>, linux-scsi <linux-scsi@vger.kernel.org>

On 07/27/2012 07:28 PM, Moger, Babu wrote:
> Submitted this patch earlier. But it still did not make it to kernel =
tree.
> Resubmitting again(recreated on top of 3.5 kernel).
> =20
> Adding all the definitions of host bytes in hostbyte_table.
>=20
> Without this patch, scsi_show_result prints hostbyte as invalid
> for statuses that are not defined in hostbyte_table(when scsi logging=
 is enabled).
>=20
> Look at scsi_print_result function for better understanding.
>=20
> Signed-off-by: Babu Moger <babu.moger@netapp.com>
Acked-by: Hannes Reinecke <hare@suse.de

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
