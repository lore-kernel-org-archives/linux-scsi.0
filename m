From: Benjamin Block <bblock@linux.vnet.ibm.com>
Subject: Re: [PATCH] zfcp: Revert to original scanning behaviour
Date: Tue, 12 Apr 2016 13:00:14 +0200
Message-ID: <20160412110014.GA16208@bblock-ThinkPad-W530>
References: <1460096094-126214-1-git-send-email-hare@suse.de>
 <yq11t6b1sld.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e06smtp09.uk.ibm.com ([195.75.94.105]:37041 "EHLO
	e06smtp09.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932651AbcDLLGK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Apr 2016 07:06:10 -0400
Received: from localhost
	by e06smtp09.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <bblock@linux.vnet.ibm.com>;
	Tue, 12 Apr 2016 12:06:07 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
	by d06dlp01.portsmouth.uk.ibm.com (Postfix) with ESMTP id 734D917D80CB
	for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2016 12:01:00 +0100 (BST)
Received: from d06av08.portsmouth.uk.ibm.com (d06av08.portsmouth.uk.ibm.com [9.149.37.249])
	by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u3CB0GKw59637790
	for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2016 11:00:16 GMT
Received: from d06av08.portsmouth.uk.ibm.com (localhost [127.0.0.1])
	by d06av08.portsmouth.uk.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u3CB0Gqc019730
	for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2016 05:00:16 -0600
Received: from bblock-ThinkPad-W530 (dyn-9-152-222-39.boeblingen.de.ibm.com [9.152.222.39])
	by d06av08.portsmouth.uk.ibm.com (8.14.4/8.14.4/NCO v10.0 AVin) with ESMTP id u3CB0Gd1019722
	for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2016 05:00:16 -0600
Content-Disposition: inline
In-Reply-To: <yq11t6b1sld.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On 22:14 Mon 11 Apr     , Martin K. Petersen wrote:
> >>>>> "Hannes" =3D=3D Hannes Reinecke <hare@suse.de> writes:
>=20
> Hannes> zfcp has its own mechanism for selective scanning, so revert =
to
> Hannes> the original scanning behaviour to not confuse users.
>=20
> Benjamin?
>=20

Sry, I meant to quickly test this yesterday but got carried away. As fa=
r
as I understand the patch-series this should be good.

Reviewed-by: Benjamin Block <bblock@linux.vnet.ibm.com>



                                                    Beste Gr=FC=DFe / B=
est regards,
                                                      - Benjamin Block
--=20
Linux on z Systems Development         /         IBM Systems & Technolo=
gy Group
		  IBM Deutschland Research & Development GmbH=20
Vorsitz. AufsR.: Martina Koederitz     /        Gesch=E4ftsf=FChrung: D=
irk Wittkopp
Sitz der Gesellschaft: B=F6blingen / Registergericht: AmtsG Stuttgart, =
HRB 243294

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
