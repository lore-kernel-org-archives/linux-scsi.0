From: "Winkler, Tomas" <tomas.winkler@intel.com>
Subject: RE: [PATCH v7 09/11] scsi: ufs: connect to RPMB subsystem
Date: Wed, 22 Mar 2017 21:25:36 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B543C0457@hasmsx108.ger.corp.intel.com>
References: <1478548394-8184-1-git-send-email-tomas.winkler@intel.com>
 <1478548394-8184-10-git-send-email-tomas.winkler@intel.com>
 <20161107190109.GA5110@lst.de>
 <5B8DA87D05A7694D9FA63FD143655C1B5431750E@hasmsx108.ger.corp.intel.com>
 <20161107213754.GA10433@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20161107213754.GA10433@lst.de>
Content-Language: en-US
Sender: linux-doc-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Ulf Hansson <ulf.hansson@linaro.org>, "Hunter, Adrian" <adrian.hunter@intel.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Vinayak Holikatti <vinholikatti@gmail.com>, Andy Lutomirski <luto@kernel.org>, Arve Hj?nnev?g <arve@android.com>, Michael Ryleev <gmar@google.com>, Joao Pinto <Joao.Pinto@synopsys.com>, Yaniv Gardi <ygardi@codeaurora.org>, Avri Altman <avri.altman@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "Usyskin, Alexander" <alexan>
List-Id: linux-scsi@vger.kernel.org

>=20
> On Mon, Nov 07, 2016 at 07:27:38PM +0000, Winkler, Tomas wrote:
> > I  value your opinion but I'm not responsible for inventing RPMB
> > and/or its  implementation storage devices (eMMC, UFC, NVMe), it's pret=
ty
> much done deal out there in the wild.
> > I'm just trying to provide common API above it.

Somehow I've missed that answer, now I got back when search for comments be=
fore I'll post a new series.
=20
> And the common API must go through the SCSI midlayer. =20

I've actually tried to do  a midlayer, but I found it's too UFS specific, s=
o there is no point to this abstraction. =20
As not all needed data are accessible via scsi calls.  The solution I propo=
se fits with what is done in eMMC (emmc specific  IOCTL).
There is already some code that breaks that layering in  ufshcd_set_dev_pwr=
_mode when talking to the special sdev_ufs.
Maybe I need more hint for the correct directions.

If it can't we won't
> support it, so please drop the UFS patches from the series.

If you have more constructive comments, I'll be glad to hear and address.=20

Thanks
Tomas

