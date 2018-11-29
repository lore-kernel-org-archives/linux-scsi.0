From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH] scsi: libsas: Add missing license and update to SPDX
 license identifier
Date: Thu, 29 Nov 2018 12:18:29 +0000
Message-ID: <b840b9bd-81e6-ebec-1fdc-fa5417a76e18@huawei.com>
References: <1543328132-243266-1-git-send-email-john.garry@huawei.com>
 <20181127144333.GA11004@kroah.com>
 <8ae3a984-b4d4-f2eb-4aaa-b460441fa403@huawei.com>
 <07b65f80-9b73-472f-1fb8-7c0133f1d1ab@huawei.com>
 <20181129121110.GA25319@kroah.com> <20181129121310.GB25319@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181129121310.GB25319@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg KH <gregkh@linuxfoundation.org>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linuxarm@huawei.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 29/11/2018 12:13, Greg KH wrote:
>>> ...
>>> > >
>>> > > MODULE_AUTHOR("Luben Tuikov <luben_tuikov@adaptec.com>");
>>> > > MODULE_DESCRIPTION("SAS Transport Layer");
>>> > > MODULE_LICENSE("GPL v2");
>>> > >
>>> > > So the license specifies v2+ but module license states v2.
>>> > >
>>> > > I could not find a docment for guidance on this. I also note that making
>>> > > sas_task.c v2 would mean mixing v2 and v2+ into the module.
>> >
>> > This is not the only file in the kernel with this problem.
>> >
>> > For now, we have been trusting the "written text" lines over the
>> > MODULE_LICENSE() lines, as that seems to be the proper way forward.
>> >
>>> > > I did find an example of someone changing the license:
>>> > > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/drivers/i2c/busses/i2c-designware-slave.c?h=v4.20-rc4&id=15c566fcff9cc7b8fd64461d6ee6fd1bc665b444
>>> > >
>> >
>> > Yup, not good, that should be fixed.
> I take it back, the changelog for the patch explains what is happening
> here, the people involved were paying attention.
>

OK, but these sample patches were just some I selected at random. May be 
many more (incorrect)...

Cheers,
John

> greg k-h
>
> .
>
