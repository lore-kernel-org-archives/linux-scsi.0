From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH 2/2] Avoid that SCSI device removal through sysfs triggers
 a deadlock
Date: Wed, 1 Aug 2018 22:58:31 +0000
Message-ID: <2a48b26b1cc1704ec7335919e9f9780f9c04d7b4.camel@wdc.com>
References: <20180730184052.13442-1-bart.vanassche@wdc.com>
         <20180730184052.13442-3-bart.vanassche@wdc.com>
         <d076a12d92469e94b584cf0f823697083f12d743.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-7"
Content-Transfer-Encoding: quoted-printable
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <d076a12d92469e94b584cf0f823697083f12d743.camel@wdc.com>
Content-Language: en-US
Content-ID: <FBBCF49D44EC26438D64AB6B94245BC0@namprd04.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
To: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "tj@kernel.org" <tj@kernel.org>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2018-08-01 at 21:16 +-0000, Bart Van Assche wrote:
+AD4- During my kernel tests of today I noticed that this patch makes booti=
ng
+AD4- significantly slower: boot time for a VM increases from 6s to 157s. M=
artin,
+AD4- please drop this patch series.

Please ignore my previous message - these two patches are fine. The trouble
was caused by a patch in another tree that I had merged in during my tests.
I will repost this series.

Bart.
