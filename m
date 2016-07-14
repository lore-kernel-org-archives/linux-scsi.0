From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] megaraid_sas: Do not fire MR_DCMD_PD_LIST_QUERY to controllers which do not support it
Date: Wed, 13 Jul 2016 22:30:16 -0400
Message-ID: <yq137ndlznr.fsf@sermon.lab.mkp.net>
References: <1467973816-17448-1-git-send-email-sumit.saxena@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1467973816-17448-1-git-send-email-sumit.saxena@broadcom.com>
	(Sumit Saxena's message of "Fri, 8 Jul 2016 03:30:16 -0700")
Sender: stable-owner@vger.kernel.org
To: Sumit Saxena <sumit.saxena@broadcom.com>
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, kashyap.desai@broadcom.com, lucz@geza.com, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Sumit" =3D=3D Sumit Saxena <sumit.saxena@broadcom.com> writes:

Sumit> There was an issue reported by Lucz Geza on Dell Perc 6i. As per
Sumit> issue reported, megaraid_sas driver goes into an infinite error
Sumit> reporting loop as soon as there is a change in the status of one
Sumit> of the arrays (degrade, resync online etc =E2=80=A6).  Below are=
 the
Sumit> error logs reported continuously-

Applied to 4.8/scsi-queue.

--=20
Martin K. Petersen	Oracle Linux Engineering
