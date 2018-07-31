From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH v2 3/9] scsi: build scsi_common.o for all scsi passthrough
 request users
Date: Tue, 31 Jul 2018 20:01:16 +0000
Message-ID: <a5b545eade66f95c9a9ecf37676306a8d395187c.camel@wdc.com>
References: <20180731195155.46664-1-keescook@chromium.org>
         <20180731195155.46664-4-keescook@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-7"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180731195155.46664-4-keescook@chromium.org>
Content-Language: en-US
Content-ID: <8F9E7D0EF0A4754382FB1A62F847D9D8@namprd04.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "keescook@chromium.org" <keescook@chromium.org>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "vinod.koul@intel.com" <vinod.koul@intel.com>, "david.kershner@unisys.com" <david.kershner@unisys.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "rdunlap@infradead.org" <rdunlap@infradead.org>, "u.kleine-koenig@pengutronix.de" <u.kleine-koenig@pengutronix.de>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>, "tglx@linutronix.de" <tglx@linutronix.de>, "hch@lst.de" <hch@lst.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "manoj@linux.vnet.ibm.com" <manoj@linux.vnet.ibm.com>, "sdharia@codeaurora.org" <sdharia@codeaurora.org>, "jgross@suse.com" <jgross@suse.com>, "cyrille.pitchen@free-electrons.com" <cyrille.pitchen@free-electrons.com>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2018-07-31 at 12:51 -0700, Kees Cook wrote:
+AD4- diff --git a/drivers/Makefile b/drivers/Makefile
+AD4- index 24cd47014657..a6abd7a856c6 100644
+AD4- --- a/drivers/Makefile
+AD4- +-+-+- b/drivers/Makefile
+AD4- +AEAAQA- -76,7 +-76,7 +AEAAQA- obj-+ACQ-(CONFIG+AF8-DMA+AF8-SHARED+AF=
8-BUFFER) +-+AD0- dma-buf/
+AD4-  obj-+ACQ-(CONFIG+AF8-NUBUS)		+-+AD0- nubus/
+AD4-  obj-y				+-+AD0- macintosh/
+AD4-  obj-+ACQ-(CONFIG+AF8-IDE)		+-+AD0- ide/
+AD4- -obj-+ACQ-(CONFIG+AF8-SCSI)		+-+AD0- scsi/
+AD4- +-obj-y				+-+AD0- scsi/
+AD4-  obj-y				+-+AD0- nvme/
+AD4-  obj-+ACQ-(CONFIG+AF8-ATA)		+-+AD0- ata/
+AD4-  obj-+ACQ-(CONFIG+AF8-TARGET+AF8-CORE)	+-+AD0- target/

The above change not only selects scsi+AF8-common.o but also the following =
object
files: scsi.o hosts.o scsi+AF8-ioctl.o scsicam.o scsi+AF8-error.o scsi+AF8-=
lib.o scsi+AF8-scan.o
scsi+AF8-sysfs.o scsi+AF8-devinfo.o scsi+AF8-trace.o scsi+AF8-logging.o. Th=
at is a change that
has not been mentioned in the patch description. That makes me wonder wheth=
er
this is an intended change? Wouldn't a cleaner solution have been to move
scsi+AF8-common.c into a new directory?

Bart.
