From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [4.18.0-rc4][bisected a063057d][mpt3sas] WARNING: CPU: 87 PID:
 18868 at block/blk-core.c:781 blk_cleanup_queue+0x20c/0x220
Date: Mon, 16 Jul 2018 14:00:27 +0000
Message-ID: <453e3f042dfbb4c848cb434db888f9051c58686a.camel@wdc.com>
References: <1531731189.15016.15.camel@abdul.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-7"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1531731189.15016.15.camel@abdul.in.ibm.com>
Content-Language: en-US
Content-ID: <3063EAC5A5FA7149A3E23C37E83455EE@namprd04.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>, "abdhalee@linux.vnet.ibm.com" <abdhalee@linux.vnet.ibm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "dougmill@linux.vnet.ibm.com" <dougmill@linux.vnet.ibm.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "sachinp@linux.vnet.ibm.com" <sachinp@linux.vnet.ibm.com>, "jack@suse.com" <jack@suse.com>, "mpe@ellerman.id.au" <mpe@ellerman.id.au>, "MPT-FusionLinux.pdl@broadcom.com" <MPT-FusionLinux.pdl@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2018-07-16 at 14:23 +-0530, Abdul Haleem wrote:
+AD4- mpt3sas module unload triggered a warning at block/blk-core.c:781 on =
a
+AD4- powerpc bare-metal running mainline kernel
+AD4-=20
+AD4- WARN+AF8-ON+AF8-ONCE() was introduced with commit a063057 : block: Fi=
x a race
+AD4- between request queue removal and the block cgroup controller

Please check whether the following patch series fixes this regression: +AFs=
-PATCH
v3 0/2+AF0- Ensure that a request queue is dissociated from the cgroup cont=
roller
(https://www.mail-archive.com/linux-block+AEA-vger.kernel.org/msg21897.html=
).

Thanks,

Bart.
