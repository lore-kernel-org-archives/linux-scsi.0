From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [target:nvme_of 3/3] drivers/target/nvme_of/nvme_of_configfs.c:25:31:
 sparse: symbol 'nvme_of_fabric_configfs' was not declared. Should it be static?
Date: Wed, 07 Jan 2015 10:57:58 +0200
Message-ID: <54ACF516.4080602@dev.mellanox.co.il>
References: <201501070334.EgwC5iey%fengguang.wu@intel.com> <1420584282.6927.62.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1420584282.6927.62.camel@haakon3.risingtidesystems.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 1/7/2015 12:44 AM, Nicholas A. Bellinger wrote:
> On Wed, 2015-01-07 at 03:35 +0800, kbuild test robot wrote:
>> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git nvme_of
>> head:   40d8c11927282d59855d645b35798edd97828da5
>> commit: 40d8c11927282d59855d645b35798edd97828da5 [3/3] nvme_of: Initial skeleton commit
>> reproduce:
>>    # apt-get install sparse
>>    git checkout 40d8c11927282d59855d645b35798edd97828da5
>>    make ARCH=x86_64 allmodconfig
>>    make C=1 CF=-D__CHECK_ENDIAN__
>>
>>
>> sparse warnings: (new ones prefixed by >>)
>>
>>>> drivers/target/nvme_of/nvme_of_configfs.c:25:31: sparse: symbol 'nvme_of_fabric_configfs' was not declared. Should it be static?
>>
>> Please review and possibly fold the followup patch.
>>
>
> Fixed.  Thanks Fengguang!
>

Hey Nic,

Hope all is well.

So this skeleton is interesting to me. As this is a fabric module I
assume this would be the NVMEoFabrics target mode driver for upstream 
which would be able to talk to NVMEoFabrics initiator (which by
the way makes LIO something more than a SCSI target - will this be 
accepted?).

I'm currently participating in nvmexpress working group defining the
standard of protocol, specifically in the context of RDMA (naturally).

I'm interested in taking an active role in this project, It is
important to build this layered from day one - separating the fabric 
logic (RDMA or FCoE) from the core layer.

Moreover, I know that Mellanox has some plans on accelerating this
area in future devices and we are currently looking into ways to
do that. I want to see that the SW will be able to support that.

So, Thoughts?

Sagi.
