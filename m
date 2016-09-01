From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 1/2] wd719x: Remove last declaration using
 DEFINE_PCI_DEVICE_TABLE
Date: Thu, 1 Sep 2016 01:00:40 +0000
Message-ID: <BLUPR02MB1683393811D77C9639F708F081E20@BLUPR02MB1683.namprd02.prod.outlook.com>
References: <cover.1472660229.git.joe@perches.com>
 <95c5e4100c3cd4eda643624f5b70e8d7abceb86c.1472660229.git.joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Joe Perches <joe@perches.com>, Andrew Morton <akpm@linux-foundation.org>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 08/31/16 09:19, Joe Perches wrote:=0A=
> Convert it to the preferred const struct pci_device_id instead.=0A=
=0A=
Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>=0A=
