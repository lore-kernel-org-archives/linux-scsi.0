From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH v2 3/9] scsi: build scsi_common.o for all scsi passthrough
 request users
Date: Tue, 31 Jul 2018 20:18:30 +0000
Message-ID: <6c04fc087bae896bf00b94184def3d7697a22d6c.camel@wdc.com>
References: <20180731195155.46664-1-keescook@chromium.org>
         <20180731195155.46664-4-keescook@chromium.org>
         <a5b545eade66f95c9a9ecf37676306a8d395187c.camel@wdc.com>
         <20180731201225.GA1989@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-7"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180731201225.GA1989@infradead.org>
Content-Language: en-US
Content-ID: <0AF1FA13400D144B90C65F56A5693E36@namprd04.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "hch@infradead.org" <hch@infradead.org>
Cc: "vinod.koul@intel.com" <vinod.koul@intel.com>, "david.kershner@unisys.com" <david.kershner@unisys.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "keescook@chromium.org" <keescook@chromium.org>, "rdunlap@infradead.org" <rdunlap@infradead.org>, "u.kleine-koenig@pengutronix.de" <u.kleine-koenig@pengutronix.de>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>, "tglx@linutronix.de" <tglx@linutronix.de>, "hch@lst.de" <hch@lst.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "manoj@linux.vnet.ibm.com" <manoj@linux.vnet.ibm.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "jgross@suse.com" <jgross@suse.com>, "cyrille.pitchen@free-electrons.com" <cyrille.pitchen@free-electrons.com>, "sdharia@codeaurora.org" <sdharia@codeaurora.org>, viresh.
List-Id: linux-scsi@vger.kernel.org

On Tue, 2018-07-31 at 13:12 -0700, hch+AEA-infradead.org wrote:
+AD4- It shouldn't.  All these are built into scsi+AF8-mod.o, which is only=
 built
+AD4- when CONFIG+AF8-SCSI is set.  Under what circumstances do you see the=
m built?

Although I think you are right, I still prefer that the scsi+AF8-common.c f=
ile
would be moved to a new directory. That will prevent confusion later on for
people who want to add additional code. This patch makes it nontrivial to
figure out which code is built when SCSI target functionality is enabled bu=
t
SCSI initiator functionality is not selected. I think moving scsi+AF8-commo=
n.c
into a new directory would make it much easier to figure out which code is
built depending on the kernel configuration.

Bart.
