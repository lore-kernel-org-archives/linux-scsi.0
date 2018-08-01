From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH 2/2] Avoid that SCSI device removal through sysfs triggers
 a deadlock
Date: Wed, 1 Aug 2018 21:16:13 +0000
Message-ID: <d076a12d92469e94b584cf0f823697083f12d743.camel@wdc.com>
References: <20180730184052.13442-1-bart.vanassche@wdc.com>
         <20180730184052.13442-3-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-7"
Content-Transfer-Encoding: quoted-printable
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180730184052.13442-3-bart.vanassche@wdc.com>
Content-Language: en-US
Content-ID: <46983511DA62A348BBD3A838197F5A73@namprd04.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
To: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "tj@kernel.org" <tj@kernel.org>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2018-07-30 at 11:40 -0700, Bart Van Assche wrote:
+AD4- A long time ago the unfortunate decision was taken to add a self-
+AD4- deletion attribute to the sysfs SCSI device directory. That decision
+AD4- was unfortunate because self-deletion is really tricky. We can't drop
+AD4- that attribute because widely used user space software depends on it,
+AD4- namely the rescan-scsi-bus.sh script. Hence this patch that avoids
+AD4- that writing into that attribute triggers a deadlock. See also commit
+AD4- 7973cbd9fbd9 (+ACIAWw-PATCH+AF0- add sysfs attributes to scan and del=
ete
+AD4- scsi+AF8-devices+ACI-).

+AFs- ... +AF0-

During my kernel tests of today I noticed that this patch makes booting
significantly slower: boot time for a VM increases from 6s to 157s. Martin,
please drop this patch series.

Thanks,

Bart.
