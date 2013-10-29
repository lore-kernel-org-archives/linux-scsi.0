From: Joseph Salisbury <joseph.salisbury@canonical.com>
Subject: Re: Subject:  [v3.8][v3.11][Regression] [SCSI] sd: Update WRITE SAME
 heuristics
Date: Tue, 29 Oct 2013 15:53:33 -0400
Message-ID: <5270123D.5030305@canonical.com>
References: <52700AD2.6000703@canonical.com> <52700F86.4010007@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <52700F86.4010007@interlog.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dgilbert@interlog.com, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: hpa@zytor.com, bernd.schubert@itwm.fraunhofer.de, JBottomley@Parallels.com, LKML <linux-kernel@vger.kernel.org>, Kamal Mostafa <kamal.mostafa@canonical.com>, linux-scsi@vger.kernel.org, Luis Henriques <luis.henriques@canonical.com>
List-Id: linux-scsi@vger.kernel.org

On 10/29/2013 03:41 PM, Douglas Gilbert wrote:
> On 13-10-29 03:21 PM, Joseph Salisbury wrote:
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
>>
>> Thanks,
>>
>> Joe
>>
>> [0] http://pad.lv/1237392
>
> Tried the other approach?
>
> From your bug report: "Areca Raid Controller2: F/W v1.46 ...(etc)..."
>
> Then see:
>   http://www.areca.com.tw/support/main.htm
>
> Doug Gilbert
>
>
>
Thanks, Doug.  I'm going to give the patch[0] written by Bernd Schubert
a try first.  If the issue still persists, I'll ask the bug reporter to
upgrade the firmware.

[0]
http://git.kernel.org/cgit/linux/kernel/git/jejb/scsi.git/commit/?id=735e39e680256a13e7be3492acfb4d9721287a42
