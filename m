From: Sitsofe Wheeler <sitsofe@gmail.com>
Subject: Re: BUG and Oops while trying to issue a discard to LVM on RAID1 md
Date: Wed, 5 Oct 2016 16:04:09 +0100
Message-ID: <CALjAwxjojE4BJaf=g7i0mexryExuMvkr9tT_5JfzD+janCrYSw@mail.gmail.com>
References: <CALjAwxjOeTvpSWaFXn+LftOVC=R1=RsbERCpfX3Tt448zoKwVw@mail.gmail.com>
 <CALjAwxiFUS4RWvM7xSxQQibCUuM+Yp8Qsk3-bJKfbD6M7z5i3w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALjAwxiFUS4RWvM7xSxQQibCUuM+Yp8Qsk3-bJKfbD6M7z5i3w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jim Gill <jgill@vmware.com>
Cc: VMware PV-Drivers <pv-drivers@vmware.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 4 October 2016 at 07:20, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
> On 4 October 2016 at 07:17, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
>> While trying to do a discard inside an ESXi 6 VM to an LVM device atop
>> an md RAID1 device composed of two SATA SSDs passed up as a raw disk
>> mappings through a PVSCSI controller, this BUG followed by an Oops was
>> hit:
>>
>> [   86.902888] ------------[ cut here ]------------
>> [   86.904600] kernel BUG at arch/x86/kernel/pci-nommu.c:66!

On a 4.8.0 kernel the problem seems to have shifted a bit:


-- 
Sitsofe | http://sucs.org/~sits/
