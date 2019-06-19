From: Michael Schmitz <schmitzmic@gmail.com>
Subject: Re: [PATCH v2 2/7] scsi: NCR5380: Always re-enable reselection
 interrupt
Date: Wed, 19 Jun 2019 13:47:23 +1200
Message-ID: <237c4979-c7ab-22d9-35ca-dda1afab2d11@gmail.com>
References: <cover.1560043151.git.fthain@telegraphics.com.au>
 <61f0c0f6aaf8fa96bf3dade5475615b2cfbc8846.1560043151.git.fthain@telegraphics.com.au>
 <58081aba-4e77-3c8e-847e-0698cf80e426@gmail.com>
 <alpine.LNX.2.21.1906111926330.25@nippy.intranet>
 <9c61076b-81f7-dc7b-0103-1e2e56072453@gmail.com> <yq1wohixux1.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <yq1wohixux1.fsf@oracle.com>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <jejb@linux.ibm.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Martin,

On 19/06/19 12:47 PM, Martin K. Petersen wrote:
> Michael,
>
>> No matter - patch applied cleanly to what I'm running on my Falcon,
>> and works just fine for now (stresstest will take a few hours to
>> complete). And that'll thoroughly exercise the reselection code path,
>> from what we've seen before.
> How did it go?


Just fine - repeated with different settings for can_queue and 
cmd_per_lun, with not a single hitch. No regression at all.

Cheers,

     Michael



>
