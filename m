From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH RESEND 17/18] megaraid_sas : fix megasas_fire_cmd_fusion
 calling convention
Date: Tue, 21 Apr 2015 12:32:37 +0200
Message-ID: <55362745.6040503@suse.de>
References: <201504201237.t3KCbMCa016895@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33443 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751482AbbDUKcj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Apr 2015 06:32:39 -0400
In-Reply-To: <201504201237.t3KCbMCa016895@palmhbs0.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumit.Saxena@avagotech.com, linux-scsi@vger.kernel.org
Cc: thenzl@redhat.com, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com

On 04/20/2015 02:35 PM, Sumit.Saxena@avagotech.com wrote:
> The fusion HBAs don't really use the instance template like the other
> variants, as it branches off at a much higher level.  So instead of
> trying to squeeze megasas_fire_cmd_fusion into the wrong calling
> convention call it locally with argument data types that match what
> is passed.
>=20
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
> ---
Reviewed-by: Hannes Reinecke <hare@suse.de>

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
