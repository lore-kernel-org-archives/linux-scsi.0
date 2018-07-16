From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH V6] scsi: ufs: Add configfs support for UFS provisioning
Date: Mon, 16 Jul 2018 14:02:52 +0000
Message-ID: <2c6a82d0fe7819c5fef3946a50a132ed1a11e71d.camel@wdc.com>
References: <1531734237-27421-1-git-send-email-sayalil@codeaurora.org>
         <1531734237-27421-2-git-send-email-sayalil@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-7"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1531734237-27421-2-git-send-email-sayalil@codeaurora.org>
Content-Language: en-US
Content-ID: <CD4FE2C05E3F91408CC0E10EC8BAB3DF@namprd04.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "vinholikatti@gmail.com" <vinholikatti@gmail.com>, "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>, "sayalil@codeaurora.org" <sayalil@codeaurora.org>, "riteshh@codeaurora.org" <riteshh@codeaurora.org>, "evgreen@chromium.org" <evgreen@chromium.org>, "cang@codeaurora.org" <cang@codeaurora.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "subhashj@codeaurora.org" <subhashj@codeaurora.org>, "vivek.gautam@codeaurora.org" <vivek.gautam@codeaurora.org>, "rnayak@codeaurora.org" <rnayak@codeaurora.org>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2018-07-16 at 15:13 +-0530, Sayali Lokhande wrote:
+AD4- +-		This file shows the current ufs configuration descriptor set in d=
evice.
+AD4- +-		This can be used to provision ufs device if bConfigDescrLock is 0=
.
+AD4- +-		For more details, refer 14.1.6.3 Configuration Descriptor and
+AD4- +-		Table 14-12 - Unit Descriptor configurable parameters from specs =
for
+AD4- +-		description of each configuration descriptor parameter.
+AD4- +-		Configuration descriptor buffer needs to be passed in space separ=
ated
+AD4- +-		format specificied as below:
+AD4- +-		echo +ADw-bLength+AD4- +ADw-bDescriptorIDN+AD4- +ADw-bConfDescCon=
tinue+AD4- +ADw-bBootEnable+AD4-
+AD4- +-		+ADw-bDescrAccessEn+AD4- +ADw-bInitPowerMode+AD4- +ADw-bHighPrior=
ityLUN+AD4-
+AD4- +-		+ADw-bSecureRemovalType+AD4- +ADw-bInitActiveICCLevel+AD4- +ADw-w=
PeriodicRTCUpdate+AD4-
+AD4- +-		+ADw-0Bh:0Fh+AF8-ReservedAs+AF8-0+AD4- +ADw-bLUEnable+AD4- +ADw-b=
BootLunID+AD4- +ADw-bLUWriteProtect+AD4-
+AD4- +-		+ADw-bMemoryType+AD4- +ADw-dNumAllocUnits+AD4- +ADw-bDataReliabil=
ity+AD4- +ADw-bLogicalBlockSize+AD4-
+AD4- +-		+ADw-bProvisioningType+AD4- +ADw-wContextCapabilities+AD4- +ADw-0=
Dh:0Fh+AF8-ReservedAs+AF8-0+AD4-
+AD4- +-		+AD4- /config/XXXX.ufshc/ufs+AF8-provision

I think the person who suggested to use configfs expected you to create one=
 configfs
attribute per value instead of writing a long list of values into a single =
configfs
attribute.

Bart.
