From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: iSCSI request keep rejected by microsoft iSCSI target because of write_same check
Date: Tue, 02 Dec 2014 22:09:50 -0500
Message-ID: <yq17fy9mnsx.fsf@sermon.lab.mkp.net>
References: <52CE77FB.8020100@oracle.com> <52CEEC97.8050108@cs.wisc.edu>
	<52CF8F0C.3040304@oracle.com> <52CFA440.7030104@cs.wisc.edu>
	<52CFAA9F.5010706@oracle.com> <52D056E9.8080008@cs.wisc.edu>
	<52D09CE6.80200@oracle.com>
	<a90377a8-3ef9-4fc2-a3e9-bfff23560674@googlegroups.com>
	<547C2E4D.1030802@oracle.com>
	<E12134C3-7E50-4E13-94FE-7CEDCB7D9537@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36800 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077AbaLCDMA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Dec 2014 22:12:00 -0500
In-Reply-To: <E12134C3-7E50-4E13-94FE-7CEDCB7D9537@cs.wisc.edu> (Michael
	Christie's message of "Mon, 1 Dec 2014 12:37:37 -0600")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Christie <michaelc@cs.wisc.edu>
Cc: open-iscsi@googlegroups.com, jazz@deti74.ru, martin.petersen@oracle.com, linux-scsi@vger.kernel.org

>>>>> "Mike" =3D=3D Michael Christie <michaelc@cs.wisc.edu> writes:

Mike,

Mike> This was the issue we worked with Microsoft on wasn=E2=80=99t it?=
 You guys
Mike> figured out it was fixed in their target in a recent release
Mike> right?

The issue we worked recently was wrt. the thin provisioning reporting.

The WRITE SAME problem was that the target returns an iSCSI-specific
error code rather than a check condition with ILLEGAL REQUEST. You were
going to talk to MS.

However, if somebody sends me the relevant INQUIRY strings for the MS
target I'll add it to the WRITE SAME quirk list.

--=20
Martin K. Petersen	Oracle Linux Engineering
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
