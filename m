From: "Ly, Bryant" <bly@catalogicsoftware.com>
Subject: Re: [PATCHv3 1/2] scsi: ibmvscsis: Fix a stringop-overflow warning
Date: Tue, 18 Sep 2018 00:37:11 +0000
Message-ID: <B86907DE-444B-498D-A402-78190A5A402B@catalogicsoftware.com>
References: <20180911192226.3620-1-labbott@redhat.com>
 <20180911192226.3620-2-labbott@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180911192226.3620-2-labbott@redhat.com>
Content-Language: en-US
Content-ID: <D061C8A3AE55F84DBF2C3151C325DDD4@prod.exchangelabs.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Laura Abbott <labbott@redhat.com>
Cc: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>, Michael Cyr <mikecyr@linux.vnet.ibm.com>, Kees Cook <keescook@chromium.org>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org



> On Sep 11, 2018, at 2:22 PM, Laura Abbott <labbott@redhat.com> wrote:
>=20
> There's currently a warning about string overflow with strncat:
>=20
> drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c: In function 'ibmvscsis_probe':
> drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c:3479:2: error: 'strncat' specifi=
ed
> bound 64 equals destination size [-Werror=3Dstringop-overflow=3D]
>  strncat(vscsi->eye, vdev->name, MAX_EYE);
>  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>=20
> Switch to a single snprintf instead of a strcpy + strcat to handle this
> cleanly.
>=20
> Signed-off-by: Laura Abbott <labbott@redhat.com>
> ---
> v3: Make sure there is an extra space in the partition name
> ---
> drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c | 3 +--
> 1 file changed, 1 insertion(+), 2 deletions(-)
>=20

Reviewed-by: Bryant G. Ly bly@catalogicsoftware.com

I sent a PR to update my email from bryantly@linux.vnet.ibm.com a week ago.

-Bryant
