From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [mpt3sas driver 07/10] mpt3sas: Add support for configurable
 Chain Frame Size
Date: Mon, 8 Feb 2016 14:55:13 +0100
Message-ID: <56B89E41.5090500@redhat.com>
References: <1453963027-19770-1-git-send-email-suganath-prabu.subramani@avagotech.com>
 <1453963027-19770-8-git-send-email-suganath-prabu.subramani@avagotech.com>
 <56B368C2.8080607@redhat.com>
 <CAK=zhgpHxib0kcXXRH7o-dRew0aUwFTdAXsLxOun4RZVgsw+Rw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAK=zhgpHxib0kcXXRH7o-dRew0aUwFTdAXsLxOun4RZVgsw+Rw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc: Suganath prabu Subaramani <suganath-prabu.subramani@avagotech.com>, "jejb@kernel.org" <jejb@kernel.org>, Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Sathya Prakash <Sathya.Prakash@avagotech.com>, Kashyap Desai <kashyap.desai@avagotech.com>, Krishnaraddi Mankani <krishnaraddi.mankani@avagotech.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Chaitra Basappa <chaitra.basappa@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>
List-Id: linux-scsi@vger.kernel.org

On 5.2.2016 08:56, Sreekanth Reddy wrote:
> On Thu, Feb 4, 2016 at 8:35 PM, Tomas Henzl <thenzl@redhat.com> wrote:
>> On 28.1.2016 07:37, Suganath prabu Subaramani wrote:
>>> From: Suganath prabu Subramani <suganath-prabu.subramani@avagotech.com>
>>>
>>> Added support for configurable Chain Frame Size. Calculate the
>>> Chain Message Frame size from the IOCMaxChainSegementSize (iocfacts).
>>> Applicable only for mpt3sas/SAS3.0 HBA's.
>>>
>>> Signed-off-by: Suganath prabu Subramani <suganath-prabu.subramani@avagotech.com>
>>> Signed-off-by: Chaitra P B <chaitra.basappa@avagotech.com>
>> Is this done in order to prepare for some future patch, or how  does it work?
>> I noticed only changes in allocation of (probably larger) fields, but
>> how is it actually used ?
> Tomas,
>
> In this patch set we have added new Intruder and Cutlass (high ports)
> PCI devices which are based on MPI26 version.
> In this MPI26 version, Request Frame size is doubled when compared to
> older MPI version, but their is
> no change in the Chain buffer size from MPI26 to older versions. In
> older version Request frame size and
> chain buffer size were same, so in the drivers previously we used to
> use Request Frame size reference for
> Chain buffer size. But we can't use that reference now. So now we are
> determining the chain buffer size from
> IOCFact's IOCMaxChainSegementSize field instead of using the Request
> frame size reference.
>
> ~Sreekanth

Thanks,

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas
