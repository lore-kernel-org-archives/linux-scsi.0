From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 0/3] libsas: add support for port multiplier
Date: Fri, 2 May 2014 08:37:29 -0700
Message-ID: <CAPcyv4h6+Wuh+NuOAfrN3bCSe877xEz_8nReZrX+K5jN9Oroeg@mail.gmail.com>
References: <1398346023-10225-1-git-send-email-yxlraid@gmail.com>
	<20140502153617.GH10204@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20140502153617.GH10204@htj.dyndns.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Xiangliang Yu <yxlraid@gmail.com>, James Bottomley <JBottomley@parallels.com>, Todd E Brandt <todd.e.brandt@intel.com>, Lukasz Dorau <lukasz.dorau@intel.com>, IDE/ATA development list <linux-ide@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, May 2, 2014 at 8:36 AM, Tejun Heo <tj@kernel.org> wrote:
> On Thu, Apr 24, 2014 at 09:27:03PM +0800, Xiangliang Yu wrote:
>> This patch set will support SATA port multiplier(PM) in LIBSAS.
>>
>> LIBSAS is need to implement several key handling to support SATA PM:
>> First,low level driver notify libsas that SATA PM is attached to HBA port.
>> Then, LIBSAS will need to schedule SATA PMP error handler to scan SATA device
>> that is attached to PM, so we must implemet port softreset and PMP reset
>> handling.
>> If find SATA devices, we should add the devices into SAS transport layer.
>> In order to find SAS domain device we must implemet device type transformation
>> : scsi device -> (port number) -> ata device -> domain device. Then, we can
>> execute IO operation.
>>
>> In these patches, patch 1 is change SATA error handler.
>> And patch 2 will add SATA device into SAS layer and implement device type
>> transformation. Patch 3 implement SATA functional interface in mvsas.
>
> Please properly thread the patchset from the next posting.
>
> Dan, can you please take a look at this?
>

Yeah, it's on my plate to look at...
