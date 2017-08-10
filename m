From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: SCSI Oops: Unable to handle kernel NULL ptr dereference
Date: Thu, 10 Aug 2017 17:38:53 +0000
Message-ID: <BY1PR0401MB15320228512D5A61BFFD5D3998880@BY1PR0401MB1532.namprd04.prod.outlook.com>
References: <20170810170537.Horde.8CxBesYMH_QVGbAB7dui6vz@www.vfemail.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "manday@openmail.cc" <manday@openmail.cc>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 08/10/17 10:05, manday@openmail.cc wrote:=0A=
> I'd like to report this rare panic I experienced today. I've been on =0A=
> 4.12.3 since it was released and got this panic totally unexpected, =0A=
> probably when terminating my WL compositor. I attach to this message a =
=0A=
> capture of the screen. The problem occurred never before and never after =
=0A=
> since, suggesting I will not be able to reproduce it easily. Perhaps it =
=0A=
> means something to someone.=0A=
> =0A=
> Linux air 4.12.3 #4 SMP Fri Jul 28 12:07:06 CEST 2017 x86_64 Intel(R) =0A=
> Core(TM)i5-6267U CPU @ 2.90GHz GenuineIntel GNU/Linux=0A=
=0A=
Hello Cedric,=0A=
=0A=
A fix for this bug is available in kernel v4.12.4. Please upgrade your =0A=
kernel. See also =0A=
https://www.mail-archive.com/linux-scsi@vger.kernel.org/msg64543.html.=0A=
=0A=
Bart.=0A=
