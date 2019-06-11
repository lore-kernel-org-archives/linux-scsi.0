From: Michael Schmitz <schmitzmic@gmail.com>
Subject: Re: [PATCH v2 2/7] scsi: NCR5380: Always re-enable reselection
 interrupt
Date: Wed, 12 Jun 2019 11:46:59 +1200
Message-ID: <9c61076b-81f7-dc7b-0103-1e2e56072453@gmail.com>
References: <cover.1560043151.git.fthain@telegraphics.com.au>
 <61f0c0f6aaf8fa96bf3dade5475615b2cfbc8846.1560043151.git.fthain@telegraphics.com.au>
 <58081aba-4e77-3c8e-847e-0698cf80e426@gmail.com>
 <alpine.LNX.2.21.1906111926330.25@nippy.intranet>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.21.1906111926330.25@nippy.intranet>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Finn,

On 11/06/19 9:33 PM, Finn Thain wrote:
> On Tue, 11 Jun 2019, Michael Schmitz wrote:
>
>> Hi Finn,
>>
>> IIRC I'd tested that change as well - didn't change broken target
>> behaviour but no regressions in other respects. Add my tested-by if
>> needed.
>>
> Unfortunately I can't confirm that this is the same patch as the one you
> tested as I no longer have that commit. But Stan did test a wide variety
> of targets and I'm confident that the reselection code path was covered.
>
No matter - patch applied cleanly to what I'm running on my Falcon, and 
works just fine for now (stresstest will take a few hours to complete). 
And that'll thoroughly exercise the reselection code path, from what 
we've seen before.

Cheers,

     Michael
