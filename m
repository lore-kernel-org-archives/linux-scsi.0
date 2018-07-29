From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH, RESEND] Avoid that SCSI device removal through sysfs
 triggers a deadlock
Date: Sun, 29 Jul 2018 04:03:41 +0000
Message-ID: <c313b5f09b6636fe71eb0a6c7390c3ef51869ae7.camel@wdc.com>
References: <20180725173828.2227-1-bart.vanassche@wdc.com>
         <20180726133527.GU1934745@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-7"
Content-Transfer-Encoding: quoted-printable
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180726133527.GU1934745@devbig577.frc2.facebook.com>
Content-Language: en-US
Content-ID: <932EDA319BDFDC48A9DB916D9C56A76C@namprd04.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
To: "tj@kernel.org" <tj@kernel.org>
Cc: "mingo@kernel.org" <mingo@kernel.org>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "oleg@redhat.com" <oleg@redhat.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "ebiederm@xmission.com" <ebiederm@xmission.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.com" <hare@suse.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2018-07-26 at 06:35 -0700, Tejun Heo wrote:
+AD4- Making removal asynchronous this way sometimes causes issues because
+AD4- whether the user sees the device released or not is racy.

Hello Tejun,

How could this change cause any user-visible changes? My understanding is
that any work queued with task+AF8-work+AF8-add() is executed before system=
 call
execution leaves kernel context and returns back to user space context.

Thanks,

Bart.
