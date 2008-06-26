From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/9] scsi_dh: Implement common device table
	handling
Date: Thu, 26 Jun 2008 14:45:48 +0200
Message-ID: <48638F7C.9090602@suse.de>
References: <20080624100349.06F5A10B5DE@craiglockhart-ipmi.suse.de>
	<1214441566.32521.10.camel@chandra-ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1214441566.32521.10.camel@chandra-ubuntu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: sekharan@us.ibm.com
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, dm-devel@redhat.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Chandra,

Chandra Seetharaman wrote:
> Other than one minor issue the code looks good (sorry for the late
> realization on my part).
>=20
> Issue: scsi_dh_handler_detach() references scsi_dh with no check for
> null and scsi_dh_notifier() call it with scsi_dh =3D=3D NULL. code can =
be
> changed to get the device handler from sdev.
>=20
This is fixed in patch 7/9. I thought I had rediffed them properly,
but apparently not. Sorry for that.

Thanks for the review.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
