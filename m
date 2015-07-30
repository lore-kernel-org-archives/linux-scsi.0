From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [scsi 7/7] scsi_debug: resp_request: remove unused variable
Date: Thu, 30 Jul 2015 13:24:42 -0400
Message-ID: <yq1si85mucl.fsf@sermon.lab.mkp.net>
References: <1438091666-18113-1-git-send-email-tomas.winkler@intel.com>
	<1438091666-18113-7-git-send-email-tomas.winkler@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33539 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831AbbG3RYx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Jul 2015 13:24:53 -0400
In-Reply-To: <1438091666-18113-7-git-send-email-tomas.winkler@intel.com>
	(Tomas Winkler's message of "Tue, 28 Jul 2015 16:54:26 +0300")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

>>>>> "Tomas" =3D=3D Tomas Winkler <tomas.winkler@intel.com> writes:

Tomas> Fixes the following warning In function =E2=80=98resp_requests=E2=
=80=99:
Tomas> drivers/scsi//scsi_debug.c:1432:15: warning: variable
Tomas> =E2=80=98want_dsense=E2=80=99 set but not used [-Wunused-but-set=
-variable] bool
Tomas> dsense, want_dsense;

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

--=20
Martin K. Petersen	Oracle Linux Engineering
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
