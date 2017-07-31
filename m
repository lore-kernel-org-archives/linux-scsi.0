From: Arvind Yadav <arvind.yadav.cs@gmail.com>
Subject: Re: [PATCH 00/29] constify scsi pci_device_id.
Date: Mon, 31 Jul 2017 14:23:11 +0530
Message-ID: <6b6ba203-1352-26ed-8d7e-c14e7bb25d32@gmail.com>
References: <1501403839-8876-1-git-send-email-arvind.yadav.cs@gmail.com>
 <20170731075647.GB4316@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170731075647.GB4316@linux-x5ow.site>
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, mdr@sgi.com, hare@suse.com, aacraid@adaptec.com, matthew@wil.cx, fthain@telegraphics.com.au, schmitzmic@gmail.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, gotom@debian.or.jp, mrochs@linux.vnet.ibm.com, yokota@netlab.is.tsukuba.ac.jp, QLogic-Storage-Upstream@cavium.com, jinpu.wang@profitbricks.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org



On Monday 31 July 2017 01:26 PM, Johannes Thumshirn wrote:
> On Sun, Jul 30, 2017 at 02:07:09PM +0530, Arvind Yadav wrote:
>> pci_device_id are not supposed to change at runtime. All functions
>> working with pci_device_id provided by <linux/pci.h> work with
>> const pci_device_id. So mark the non-const structs as const.
> Can't this go all in one patch instead of replicating the same patch 29
> times?
Yes, We can add all of them in single patch. But other maintainer wants
single single patch. thats why I have send 29 patch. :(
> Thanks,
> 	Johannes
>
~arvind
