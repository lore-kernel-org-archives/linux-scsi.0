From: Joseph Salisbury <joseph.salisbury@canonical.com>
Subject: Re: Subject:  [v3.8][v3.11][Regression] [SCSI] sd: Update WRITE SAME
 heuristics
Date: Wed, 30 Oct 2013 15:28:53 -0400
Message-ID: <52715DF5.9040100@canonical.com>
References: <52700AD2.6000703@canonical.com> <5270108E.5040401@itwm.fraunhofer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5270108E.5040401@itwm.fraunhofer.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: hpa@zytor.com, JBottomley@Parallels.com, LKML <linux-kernel@vger.kernel.org>, Kamal Mostafa <kamal.mostafa@canonical.com>, linux-scsi@vger.kernel.org, Luis Henriques <luis.henriques@canonical.com>
List-Id: linux-scsi@vger.kernel.org

On 10/29/2013 03:46 PM, Bernd Schubert wrote:
> Hello Joseph,
>
> On 10/29/2013 08:21 PM, Joseph Salisbury wrote:
>> Hi Martin,
>>
>> A bug was opened against the Ubuntu kernel[0].  After a kernel bisect,
>> it was found that reverting the following commit resolved this bug:
>>
>> commit 66c28f97120e8a621afd5aa7a31c4b85c547d33d
>> Author: Martin K. Petersen <martin.petersen@oracle.com>
>> Date:   Thu Jun 6 22:15:55 2013 -0400
>>
>>      [SCSI] sd: Update WRITE SAME heuristics
>>
>>
>> The regression was introduced as of v3.11-rc1, but it also made it's way
>> into the stable trees.
>>
>> I see that you are the author of this patch, so I wanted to run this by
>> you.  I was thinking of requesting a revert for v3.12, but I wanted to
>> get your feedback first.
>>
>
> James queued this up for 3.13
>
>> http://git.kernel.org/cgit/linux/kernel/git/jejb/scsi.git/commit/?id=735e39e680256a13e7be3492acfb4d9721287a42
>>
>
> Maybe we should try to convince James to take it into 3.12?
>
>
> Cheers,
> Bernd
Hi Bernd,

The bug reporter confirms that your patch fixes the bug.  Any chance
this patch can make it into 3.12?

Thanks,

Joe
