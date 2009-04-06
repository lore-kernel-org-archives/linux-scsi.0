From: berthiaume_wayne@emc.com
Subject: RE: SCSI Hardware Handler and slow failover with large
	number ofLUNS
Date: Mon, 6 Apr 2009 13:59:29 -0400
Message-ID: <8F08A56613D77044BD153E2AC5DA0F8401AE5283@CORPUSMX40A.corp.emc.com>
References: <1238880636.11478.8.camel@chandra-ubuntu>
	<8F08A56613D77044BD153E2AC5DA0F8401A817E4@CORPUSMX40A.corp.emc.com>
	<1239040026.25764.4.camel@chandra-ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <1239040026.25764.4.camel@chandra-ubuntu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: sekharan@linux.vnet.ibm.com
Cc: dm-devel@redhat.com, linux-scsi@vger.kernel.org, Babu.Moger@lsi.com
List-Id: linux-scsi@vger.kernel.org

Hi Chandra.

	Yes, it is the dm_emc.

Regards,
Wayne.=20

-----Original Message-----
From: Chandra Seetharaman [mailto:sekharan@us.ibm.com]=20
Sent: Monday, April 06, 2009 1:47 PM
To: berthiaume, wayne
Cc: dm-devel@redhat.com; linux-scsi@vger.kernel.org; Babu.Moger@lsi.com
Subject: RE: SCSI Hardware Handler and slow failover with large number
ofLUNS


On Mon, 2009-04-06 at 11:38 -0400, berthiaume_wayne@emc.com wrote:
> Hi Chandra.
>=20
> 	We're currently testing 1024 LUNs across four paths with the
> older handler but will be doing the same with the new handler later
this

Hi Wayne,

What do you mean by "older" handler ? dm_emc ?

> month. It sounds like I should move this up in the queue.=20
>=20
> Regards,
> Wayne.=20
>=20
> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org
> [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Chandra
> Seetharaman
> Sent: Saturday, April 04, 2009 5:31 PM
> To: dm-devel; Linux SCSI Mailing list
> Cc: Moger, Babu
> Subject: SCSI Hardware Handler and slow failover with large number of
> LUNS
>=20
> Hello All,
>=20
> During testing with the latest SCSI DH Handler on a rdac storage, Babu
> found that the failover time with 100+ luns takes about 15 minutes,
> which is not good.
>=20
> We found that the problem is due to the fact that we serialize
activate
> in dm on the work queue.
>=20
> We can solve the problem in rdac handler in 2 ways
>  1. batch up the activates (mode_selects) and send few of them.
>  2. Do mode selects in async mode.
>=20
> Just wondering if anybody had seen the same problem in other storages
> (EMC, HP and Alua).=20
>=20
> Please share your experiences, so we can come up with a solution that
> works for all hardware handlers.
>=20
> regards,
>=20
> chandra
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
