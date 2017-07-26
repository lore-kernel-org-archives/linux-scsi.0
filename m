From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH, RESEND] scsi: lpfc: fix linking against modular NVMe support
Date: Wed, 26 Jul 2017 11:17:09 +0200
Message-ID: <CAK8P3a0qkM73U4kubU9457grAiUJDPBVw-YzR10-Y-wqwqZQ_Q@mail.gmail.com>
References: <20170721205401.3374331-1-arnd@arndb.de> <20170726090820.GH4039@linux-x5ow.site>
 <CAK8P3a2EnPuTNU0O5va+Xz3nCthhpz3Po1z7SOVRiAUV_2+OhA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <CAK8P3a2EnPuTNU0O5va+Xz3nCthhpz3Po1z7SOVRiAUV_2+OhA@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "# 3.4.x" <stable@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Finn Thain <fthain@telegraphics.com.au>, James Smart <jsmart2021@gmail.com>, linux-scsi <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Jul 26, 2017 at 11:16 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Wed, Jul 26, 2017 at 11:08 AM, Johannes Thumshirn <jthumshirn@suse.de> wrote:
>> On Fri, Jul 21, 2017 at 10:53:46PM +0200, Arnd Bergmann wrote:
>>> I originally sent the patch in March 2013, the day after the broken
>>                                        ^ 2017?
>
> Oops. Let me resend that.

Ah, it was only below the "---" line, so I'll skip the resending
unless you want me
to add a comment in the Kconfig file.

       Arnd
