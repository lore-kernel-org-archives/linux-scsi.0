From: Avri Altman <Avri.Altman@wdc.com>
Subject: RE: [PATCH 2/2 v4] scsi: ufs: introduce sysfs entries exposing UFS
 health info
Date: Wed, 27 Dec 2017 09:00:10 +0000
Message-ID: <DM5PR04MB10856CCEE145B2B8AADDF668FC070@DM5PR04MB1085.namprd04.prod.outlook.com>
References: <20171220191631.50329-1-jaegeuk@kernel.org>
 <20171220191631.50329-2-jaegeuk@kernel.org>
 <20171220221325.GA56741@jaegeuk-macbookpro.roam.corp.google.com>
 <20171221075935.GB9645@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171221075935.GB9645@kroah.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jaegeuk Kim <jaegeuk@kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Jaegeuk Kim <jaegeuk@google.com>, Alex Lemberg <Alex.Lemberg@wdc.com>, Stanislav Nijnikov <Stanislav.Nijnikov@wdc.com>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Greg Kroah-Hartman
> Sent: Thursday, December 21, 2017 10:00 AM
> To: Jaegeuk Kim <jaegeuk@kernel.org>
> Cc: linux-kernel@vger.kernel.org; linux-scsi@vger.kernel.org; Jaegeuk Kim
> <jaegeuk@google.com>
> Subject: Re: [PATCH 2/2 v4] scsi: ufs: introduce sysfs entries exposing U=
FS
> health info
>=20
> On Wed, Dec 20, 2017 at 02:13:25PM -0800, Jaegeuk Kim wrote:
> > This patch adds a new sysfs group, namely health, via:
> >
> >    /sys/devices/soc/X.ufshc/health/
As device health is just one piece of information out of the device managem=
ent,
I think that you should address this in a more comprehensive way,
And set hooks for much more device info:
Allow access to device descriptors, attributes and flags.
The attributes and flags should be placed in separate subfolders
The LUN specific descriptors and attributes should be placed in a luns subf=
older, and then per descriptor / attribute type
You might also would like to consider differentiating read and write - to c=
ontrol those type of accesses as well.

Cheers,
Avri
