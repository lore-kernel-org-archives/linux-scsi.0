From: Shaun Tancheff <shaun.tancheff@seagate.com>
Subject: Re: patch "libata: Add support for SCT Write Same" breaks system
Date: Fri, 9 Sep 2016 12:17:38 -0500
Message-ID: <CAJVOszAfyH1epduB1Ehu7VcEr_oMfTcqgAb+-_1nNg+x2a-Xww@mail.gmail.com>
References: <20160908192736.GA4356@gmail.com> <20160909151607.GA19609@htj.duckdns.org>
 <CAJVOszB39NfK=z-rHVWuLyz909pSVwTMRFDPFcY50Uaoj6STEQ@mail.gmail.com> <20160909153613.GB19609@htj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20160909153613.GB19609@htj.duckdns.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Mike Krinkin <krinkin.m.u@gmail.com>, Shaun Tancheff <shaun@tancheff.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Fri, Sep 9, 2016 at 10:36 AM, Tejun Heo <tj@kernel.org> wrote:
> Hello, Shaun.
>
> On Fri, Sep 09, 2016 at 10:26:44AM -0500, Shaun Tancheff wrote:
>> I'm looking into it now. Let me see if I can reproduce this on any of my
>> hardware.
>>
>> If not there are a couple of options ... one is to only enable for ZBC
>> devices
>> where this explicitly required by the spec.
>>
>> Or disable for devices that report support trim?
>
> I'd much prefer enabling this only on ZBC devices.  There isn't any
> real benefits to !ZBC devices, right?  Using non-essential features on
> ATA never goes well.

I've posted a patch for !ZBC.

Mike, can you confirm if this works for you?

>
> Thanks.
>
> --
> tejun

Thanks!

(Apologies for the html reply earlier)
-- 
Shaun Tancheff
