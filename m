From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH] scsi: osd_uld: fix mismerge
Date: Wed, 19 Apr 2017 17:46:43 +0000
Message-ID: <1492624001.2543.9.camel@sandisk.com>
References: <20170419174415.4029467-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170419174415.4029467-1-arnd@arndb.de>
Content-Language: en-US
Content-ID: <800C66E32CD2FE4C9ECE44BFF6EAE634@namprd04.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>, "arnd@arndb.de" <arnd@arndb.de>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "ooo@electrozaur.com" <ooo@electrozaur.com>, "dan.carpenter@oracle.com" <dan.carpenter@oracle.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "bhalevy@primarydata.com" <bhalevy@primarydata.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2017-04-19 at 19:44 +0200, Arnd Bergmann wrote:
> Fixes: c02465fa13b6 ("scsi: osd_uld: Check scsi_device_get() return value=
")
> Fixes: ac1ddc584e98 ("scsi: utilize new cdev_device_add helper function")

Hello Arnd,

Both these patches are fine as far as I can tell. Shouldn't the
"Fixes" tag refer to the merge commit instead of to the commits
that have been merged?

Bart.=
