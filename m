From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: Subject:  [v3.8][v3.11][Regression] [SCSI] sd: Update WRITE SAME
 heuristics
Date: Tue, 29 Oct 2013 15:41:58 -0400
Message-ID: <52700F86.4010007@interlog.com>
References: <52700AD2.6000703@canonical.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <52700AD2.6000703@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Joseph Salisbury <joseph.salisbury@canonical.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: hpa@zytor.com, bernd.schubert@itwm.fraunhofer.de, JBottomley@Parallels.com, LKML <linux-kernel@vger.kernel.org>, Kamal Mostafa <kamal.mostafa@canonical.com>, linux-scsi@vger.kernel.org, Luis Henriques <luis.henriques@canonical.com>
List-Id: linux-scsi@vger.kernel.org

On 13-10-29 03:21 PM, Joseph Salisbury wrote:
> Hi Martin,
>
> A bug was opened against the Ubuntu kernel[0].  After a kernel bisect,
> it was found that reverting the following commit resolved this bug:
>
> commit 66c28f97120e8a621afd5aa7a31c4b85c547d33d
> Author: Martin K. Petersen <martin.petersen@oracle.com>
> Date:   Thu Jun 6 22:15:55 2013 -0400
>
>      [SCSI] sd: Update WRITE SAME heuristics
>
>
> The regression was introduced as of v3.11-rc1, but it also made it's way
> into the stable trees.
>
> I see that you are the author of this patch, so I wanted to run this by
> you.  I was thinking of requesting a revert for v3.12, but I wanted to
> get your feedback first.
>
>
> Thanks,
>
> Joe
>
> [0] http://pad.lv/1237392

Tried the other approach?

 From your bug report: "Areca Raid Controller2: F/W v1.46 ...(etc)..."

Then see:
   http://www.areca.com.tw/support/main.htm

Doug Gilbert
