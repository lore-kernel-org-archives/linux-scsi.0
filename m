From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH V5 2/2] scsi: ufs: Add configfs support for ufs
 provisioning
Date: Wed, 18 Jul 2018 17:30:07 +0000
Message-ID: <16c8acaec092ef989ec20d0b006a434bc0de250c.camel@wdc.com>
References: <1530858040-13971-1-git-send-email-sayalil@codeaurora.org>
         <1530858040-13971-3-git-send-email-sayalil@codeaurora.org>
         <CAE=gft5U1-Jo-GvTF7sNAV3Q565AmuUrHpmBdxUL+UwkKxesqA@mail.gmail.com>
         <0dce9e9c-4f93-9857-72ee-f65ff195c41a@codeaurora.org>
         <CAE=gft6_=SQjgv7_kHXKJKa8_45NKKFwwE7UaXsijPpMd35LOg@mail.gmail.com>
         <4cb931e199599314829f5ff750797c88fc123f1f.camel@wdc.com>
         <CAE=gft6zm2mw3rnNuktDe0NWs-NM1CFQw1BUeGhaBi3eoEDXBg@mail.gmail.com>
         <aa697186c00937c18519fe5eb1355d3fc458cfb6.camel@wdc.com>
         <20180718085651.GA23599@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-7"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180718085651.GA23599@kroah.com>
Content-Language: en-US
Content-ID: <B6F2F304B1EC044498753A5EA62D7C74@namprd04.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc: "vinholikatti@gmail.com" <vinholikatti@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>, "sayalil@codeaurora.org" <sayalil@codeaurora.org>, "riteshh@codeaurora.org" <riteshh@codeaurora.org>, "evgreen@chromium.org" <evgreen@chromium.org>, "cang@codeaurora.org" <cang@codeaurora.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "subhashj@codeaurora.org" <subhashj@codeaurora.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "vivek.gautam@codeaurora.org" <vivek.gautam@codeaurora.org>, "rnayak@codeaurora.org" <rnayak@codeaurora.org>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2018-07-18 at 10:56 +-0200, gregkh+AEA-linuxfoundation.org wrote:
+AD4- On Tue, Jul 17, 2018 at 09:06:35PM +-0000, Bart Van Assche wrote:
+AD4- +AD4- On Tue, 2018-07-17 at 13:23 -0700, Evan Green wrote:
+AD4- +AD4- +AD4- I'm not dead set on binary, since as above I could do it =
either way,
+AD4- +AD4- +AD4- but it seemed worth at least talking through. Let me know=
 what you
+AD4- +AD4- +AD4- think.
+AD4- +AD4-=20
+AD4- +AD4- The configfs documentation (Documentation/filesystems/configfs/=
configfs.txt)
+AD4- +AD4- is clear about this: +ACI-Preferably only one value per file sh=
ould be used.+ACI- So
+AD4- +AD4- I would like to hear the opinion of someone who has more author=
ity than I
+AD4- +AD4- with regard to configfs.
+AD4-=20
+AD4- Don't we have +ACI-binary+ACI- files for configfs?  We have them for =
sysfs, they
+AD4- are for files that are not touched by the kernel and just +ACI-pass-t=
hrough+ACI-
+AD4- to the hardware.  Would that work here as well?

If a new version of the UFS spec would be introduced and that new version o=
f the
spec introduces a new layout for the binary descriptor, will it be possible=
 for
user space software to figure out which version of the binary descriptor fo=
rmat
that has to be used?

Thanks,

Bart.=
