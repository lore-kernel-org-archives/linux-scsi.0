From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH 0/15] copy offload patches
Date: Mon, 14 Dec 2015 22:43:04 -0500
Message-ID: <566F8C48.6060903@interlog.com>
References: <alpine.LRH.2.02.1512101145430.25927@file01.intranet.prod.int.rdu2.redhat.com>
 <yq1r3iuylwd.fsf@sermon.lab.mkp.net>
 <alpine.LRH.2.02.1512142018030.8189@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.02.1512142018030.8189@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, Jens Axboe <axboe@kernel.dk>, Mike Snitzer <msnitzer@redhat.com>, Jonathan Brassow <jbrassow@redhat.com>, dm-devel@redhat.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, Mike Christie <michaelc@cs.wisc.edu>
List-Id: linux-scsi@vger.kernel.org

On 15-12-14 08:22 PM, Mikulas Patocka wrote:
>
>
> On Thu, 10 Dec 2015, Martin K. Petersen wrote:
>
>>>>>>> "Mikulas" == Mikulas Patocka <mpatocka@redhat.com> writes:
>>
>> Mikulas,
>>
>> Mikulas> This patch series adds copy offload (the XCOPY command) to the
>> Mikulas> block layer, SCSI subsystems and device mapper.
>>
>> Now that the VFS stuff appears to stabilize I agree it's a good time to
>> revisit all this. I just merged the required VPD patches from Hannes so
>> those will be in 4.5.
>>
>> I have a bunch of changes to the SCSI code that I worked on over the
>> spring/summer based on a feedback from the array vendors after
>> discussions we started at LSF/MM. Generally speaking, their comments
>> didn't make things easier, nor prettier :( But your two bio approach is
>> a requirement to accommodate those needs (token-based copy) so I'll work
>> on consolidating your changes with mine.
>
> Let me know when you make some progress with that.
>
> Is there some software iSCSI implementation that supports token-based
> copy? So that I could try to make support for it.

FreeNAS. See:
    http://www.freenas.org/

It has the best ODX implementation (thanks to Alexander Motin) that
I have come across for testing my ddpt based ODX client. It also
supports large parts of the more general xcopy LID1 and LID4.


BTW In SPC-5 xcopy LID1 has been dropped and "xcopy" now means
xcopy LID4 (as found in SPC-4).

Doug Gilbert

>> That said, we still need Mike Christie's patches to go in first.
>>
>> Mike: What's your status? I'm afraid I didn't get a chance to dig very
>> deep in your series since it coincided with me scrambling to sort out
>> SCSI for 4.4. Do you think there's a chance we could get your patches in
>> shape for 4.5? Is there an up-to-date tree I can look at?
>>
>> --
>> Martin K. Petersen	Oracle Linux Engineering
