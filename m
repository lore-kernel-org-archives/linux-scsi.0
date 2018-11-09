From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH v4 2/2] scsi: ufs: Add UFS platform driver for Cadence UFS
Date: Fri, 9 Nov 2018 11:51:59 +0000
Message-ID: <c4937848-8459-1201-5ec1-2f453df15e1e@huawei.com>
References: <C77CE2E3-F88A-4B1E-BECB-5D031E2930E3@global.cadence.com>
 <1A428C77-982A-4EB8-8FDD-A33979753660@global.cadence.com>
 <yq1tvkt1vly.fsf@oracle.com>
 <38D3DEAD-C318-4BE2-8605-102FF572AD45@global.cadence.com>
 <yq1tvkrvvad.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1tvkrvvad.fsf@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Janek Kotas <jank@cadence.com>
Cc: "vinholikatti@gmail.com" <vinholikatti@gmail.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "robh+dt@kernel.org" <robh+dt@kernel.org>, "mark.rutland@arm.com" <mark.rutland@arm.com>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 09/11/2018 02:28, Martin K. Petersen wrote:
>
> Janek,
>
>>> Rob reviewed the dt binding patch but has it been merged or should I
>>> take both patches through SCSI?
>
> Applied to 4.21/scsi-queue. Thank you!
>


Hi Martin,

I am building your 4.21 queue today, and it seems to be broken from this 
patch:

https://kernel.googlesource.com/pub/scm/linux/kernel/git/mkp/scsi/+/b3874a425510d1164fd3428ab99273c07d210d82

You seemed to miss adding the c-file:
make[3]: *** No rule to make target `drivers/scsi/ufs/cdns-pltfrm.o', 
needed by `drivers/scsi/ufs/built-in.a'. Stop

Or am I missing something?

John
