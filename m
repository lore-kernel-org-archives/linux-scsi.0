From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v5 3/9] snic:Add meta request,  handling of meta requests.
Date: Mon, 11 May 2015 19:56:25 +0200
Message-ID: <5550ED49.9040902@suse.de>
References: <1429694642-22309-1-git-send-email-nmusini@cisco.com> <1429694642-22309-4-git-send-email-nmusini@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47770 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751407AbbEKR41 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 May 2015 13:56:27 -0400
In-Reply-To: <1429694642-22309-4-git-send-email-nmusini@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Narsimhulu Musini <nmusini@cisco.com>, JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: Sesidhar Baddela <sebaddel@cisco.com>

On 04/22/2015 11:23 AM, Narsimhulu Musini wrote:
> snic_io.h contains meta request structure definition
> meta request contains high level information about firmware requests.
> such as request information, size, SGLs.
>=20
> snic_io.c contains interfaces to handle meta request, firmware acknow=
ledgment,
> and high level generic queueing interface.
>=20
> Signed-off-by: Narsimhulu Musini <nmusini@cisco.com>
> Signed-off-by: Sesidhar Baddela <sebaddel@cisco.com>
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
