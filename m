From: "Bean Huo (beanhuo)" <beanhuo@micron.com>
Subject: RE: [EXT] [PATCH v4 3/3] scsi: ufs-bsg: Allow reading descriptors
Date: Thu, 31 Jan 2019 10:27:01 +0000
Message-ID: <BYAPR08MB453315E3E66C8FB0E6E89094DB910@BYAPR08MB4533.namprd08.prod.outlook.com>
References: <1548572868-12589-1-git-send-email-avri.altman@wdc.com>
 <1548572868-12589-4-git-send-email-avri.altman@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1548572868-12589-4-git-send-email-avri.altman@wdc.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Avri Altman <avri.altman@wdc.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Evan Green <evgreen@chromium.org>
Cc: Avi Shchislowski <avi.shchislowski@wdc.com>, Alex Lemberg <alex.lemberg@wdc.com>
List-Id: linux-scsi@vger.kernel.org

>-----Original Message-----
>From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
>owner@vger.kernel.org] On Behalf Of Avri Altman
>Sent: Sunday, January 27, 2019 8:08 AM
>To: James E.J. Bottomley <jejb@linux.vnet.ibm.com>; Martin K. Petersen
><martin.petersen@oracle.com>; linux-scsi@vger.kernel.org; linux-
>kernel@vger.kernel.org; Evan Green <evgreen@chromium.org>
>Cc: Avi Shchislowski <avi.shchislowski@wdc.com>; Alex Lemberg
><alex.lemberg@wdc.com>; Avri Altman <avri.altman@wdc.com>
>Subject: [EXT] [PATCH v4 3/3] scsi: ufs-bsg: Allow reading descriptors
>
>Add this functionality, placing the descriptor being read in the actual da=
ta buffer
>in the bio.
>
>That is, for both read and write descriptors query upiu, we are using the =
job's
>request_payload.  This in turn, is mapped back in user land to the applica=
ble
>sg_io_v4 xferp: dout_xferp for write descriptor, and din_xferp for read de=
scriptor.
>
>Signed-off-by: Avri Altman <avri.altman@wdc.com>
Reviewed-by: Bean Huo <beanhuo@micron.com>
