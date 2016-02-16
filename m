From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: Re: [PATCH] [SCSI] dpt_i2o: fix build warning
Date: Tue, 16 Feb 2016 23:53:35 +0530
Message-ID: <56C36927.7070405@gmail.com>
References: <1455611856-7009-1-git-send-email-sudipm.mukherjee@gmail.com> <20160216091706.GH18134@c203.arch.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160216091706.GH18134@c203.arch.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Adaptec OEM Raid Solutions <aacraid@adaptec.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tuesday 16 February 2016 02:47 PM, Johannes Thumshirn wrote:
> On Tue, Feb 16, 2016 at 02:07:36PM +0530, Sudip Mukherjee wrote:
>> We were getting build warning about:
>> drivers/scsi/dpt_i2o.c:183:29: warning: =E2=80=98dptids=E2=80=99 def=
ined but not used
>>
>> dptids[] is only used in the MODULE_DEVICE_TABLE so when MODULE is n=
ot
>> defined then dptids[] becomes unused.
>
> Nah. Care to make a proper pci driver from it instead of plastering y=
et
> another #ifdef in?

Ok. I am on it. I hope someone has the hardware to check the changes.

regards
sudip
