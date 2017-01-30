From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: RE: [PATCH V3 21/24] aacraid: Retrieve HBA host information ioctl
Date: Mon, 30 Jan 2017 19:53:15 +0000
Message-ID: <4D8E82A446BF54499747901DBDEB737A7B8A6C9A@avsrvexchmbx2.microsemi.net>
References: <20170127192853.10082-1-RaghavaAditya.Renukunta@microsemi.com>
 <20170127192853.10082-22-RaghavaAditya.Renukunta@microsemi.com>
 <20170130114314.GP3603@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0088.outbound.protection.outlook.com ([104.47.41.88]:36448
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754139AbdA3UIo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 30 Jan 2017 15:08:44 -0500
In-Reply-To: <20170130114314.GP3603@linux-x5ow.site>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Dave Carroll <david.carroll@microsemi.com>, Gana Sridaran <gana.sridaran@microsemi.com>, Scott Benesh <scott.benesh@microsemi.com>



> -----Original Message-----
> From: Johannes Thumshirn [mailto:jthumshirn@suse.de]
> Sent: Monday, January 30, 2017 3:43 AM
> To: Raghava Aditya Renukunta
> <RaghavaAditya.Renukunta@microsemi.com>
> Cc: jejb@linux.vnet.ibm.com; martin.petersen@oracle.com; linux-
> scsi@vger.kernel.org; Dave Carroll <david.carroll@microsemi.com>; Gana
> Sridaran <gana.sridaran@microsemi.com>; Scott Benesh
> <scott.benesh@microsemi.com>
> Subject: Re: [PATCH V3 21/24] aacraid: Retrieve HBA host information ioct=
l
>=20
> EXTERNAL EMAIL
>=20
>=20
> On Fri, Jan 27, 2017 at 11:28:50AM -0800, Raghava Aditya Renukunta wrote:
> > Added a new ioctl interface to retrieve the host device information.
> >
> > Signed-off-by: Raghava Aditya Renukunta
> <RaghavaAditya.Renukunta@microsemi.com>
> > Signed-off-by: Dave Carroll <David.Carroll@microsemi.com>
> >
> > ---
>=20
> [...]
>=20
> > + * This is for management ioctl purpose only.
> > + */
> > +struct aac_hba_info {
> > +
> > +     u8      DriverName[50];
> > +     u8      AdapterNumber;
> > +     u8      SystemIoBusNumber;
> > +     u8      DeviceNumber;
> > +     u32     FunctionNumber;
> > +     u32     VendorID;
> > +     u32     DeviceID;
> > +     u32     SubVendorID;
> > +     u32     SubSystemID;
> > +     u32     MappedBaseAddressSize;
> > +     u32     BasePhysicalAddress_HighPart;
> > +     u32     BasePhysicalAddress_LowPart;
> > +
> > +     u32     MaxCommandSize;
> > +     u32     MaxFibSize;
> > +     u32     MaxScatterGatherFromOs;
> > +     u32     MaxScatterGatherToFw;
> > +     u32     MaxOutstandingFibs;
> > +
> > +     u32     QueueStartThreshold;
> > +     u32     QueueDumpThreshold;
> > +     u32     MaxIoSizeQueued;
> > +     u32     OutstandingIO;
> > +
> > +     u32     FirmwareBuildNumber;
> > +     u32     BIOSBuildNumber;
> > +     u32     DriverBuildNumber;
> > +     u32     SerialNumber_HighPart;
> > +     u32     SerialNumber_LowPart;
> > +     u32     SupportedOptions;
> > +     u32     FeatureBits;
> > +     u32     currentnumberPorts;
> > +
> > +     u8      NewCommInterface:1;
> > +     u8      NewCommandsSupported:1;
> > +     u8      DisablePassthrough:1;
> > +     u8      ExposeNonDasd:1;
> > +     u8      QueueAllowed:1;
> > +     u8      BLEDCheckEnabled:1;
> > +     u8      reserved1:1;
> > +     u8      reserted2:1;
> > +
> > +     u32     reserved3[10];
> > +
> > +};
>=20
> Again, is it possible to get this without CamelCase?

Next patch version submission I will fix this.

> Anyways,
> Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
>=20
> --
> Johannes Thumshirn                                          Storage
> jthumshirn@suse.de                                +49 911 74053 689
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
> Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
