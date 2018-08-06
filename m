From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] target: fix tcm_loop build errors when SCSI=m
Date: Mon, 6 Aug 2018 23:07:34 +0000
Message-ID: <d3349291f6d04e4b8717ea478fcfd2eaf70b39f6.camel@wdc.com>
References: <5b7b9c12-d202-ab0c-9598-267468bf10ad@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-7"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5b7b9c12-d202-ab0c-9598-267468bf10ad@infradead.org>
Content-Language: en-US
Content-ID: <54E2F3FC2FA24C46ADB86ACE5025F979@namprd04.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "rdunlap@infradead.org" <rdunlap@infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2018-08-06 at 10:13 -0700, Randy Dunlap wrote:
+AD4- Fix build errors when CONFIG+AF8-SCSI+AD0-m and CONFIG+AF8-LOOPBACK+A=
F8-TARGET+AD0-y
+AD4- by making LOOPBACK+AF8-TARGET depend on SCSI.

Is this a longstanding or a new issue? In the latter case, should a Fixes:
tag be added?

Thanks,

Bart.
