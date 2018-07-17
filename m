From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH V5 2/2] scsi: ufs: Add configfs support for ufs
 provisioning
Date: Tue, 17 Jul 2018 00:04:34 +0000
Message-ID: <4cb931e199599314829f5ff750797c88fc123f1f.camel@wdc.com>
References: <1530858040-13971-1-git-send-email-sayalil@codeaurora.org>
         <1530858040-13971-3-git-send-email-sayalil@codeaurora.org>
         <CAE=gft5U1-Jo-GvTF7sNAV3Q565AmuUrHpmBdxUL+UwkKxesqA@mail.gmail.com>
         <0dce9e9c-4f93-9857-72ee-f65ff195c41a@codeaurora.org>
         <CAE=gft6_=SQjgv7_kHXKJKa8_45NKKFwwE7UaXsijPpMd35LOg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-7"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAE=gft6_=SQjgv7_kHXKJKa8_45NKKFwwE7UaXsijPpMd35LOg@mail.gmail.com>
Content-Language: en-US
Content-ID: <988A6E6B013922458A0E07071AF34D1D@namprd04.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "sayalil@codeaurora.org" <sayalil@codeaurora.org>, "evgreen@chromium.org" <evgreen@chromium.org>
Cc: "vinholikatti@gmail.com" <vinholikatti@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>, "riteshh@codeaurora.org" <riteshh@codeaurora.org>, "cang@codeaurora.org" <cang@codeaurora.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "subhashj@codeaurora.org" <subhashj@codeaurora.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "vivek.gautam@codeaurora.org" <vivek.gautam@codeaurora.org>, "rnayak@codeaurora.org" <rnayak@codeaurora.org>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2018-07-16 at 16:46 -0700, Evan Green wrote:
+AD4- I see Bart has chimed in on the next series with a suggestion to brea=
k
+AD4- out each field into individual files within configfs. Bart, what are
+AD4- your feelings about converting to a binary attribute? I remember when
+AD4- I did my sysfs equivalent of this patch, somebody chimed in indicatin=
g
+AD4- a +ACI-commit+ACI- file might be needed so that the new configuration=
 could be
+AD4- written in one fell swoop. One advantage of the binary attribute is
+AD4- that it writes the configuration atomically.

Hello Evan,

I may be missing some UFS background information. But since a configfs inte=
rface
is being added I think the same rule applies as to all Linux kernel user sp=
ace
interfaces, namely that it should be backwards compatible. Additionally, if
anyone ever will want to use this interface from a shell script, I think th=
at
it will be much easier to write multiple ASCII attributes than a single bin=
ary
attribute.

Bart.
