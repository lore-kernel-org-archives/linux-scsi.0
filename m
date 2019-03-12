From: Hannes Reinecke <hare@suse.com>
Subject: Re: [GIT PULL] first round of SCSI updates for the 5.0+ merge window
Date: Tue, 12 Mar 2019 08:22:35 +0100
Message-ID: <b4055c9e-8fc8-7585-908d-3dfac29ac915@suse.com>
References: <1551940186.8289.60.camel@HansenPartnership.com>
 <CA+8MBb+MJhS9ejWQ0+vjDyhdnK5bsuaLPwpM5f-h1-6tHr4rVg@mail.gmail.com>
 <yq1ef7dqm6v.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1ef7dqm6v.fsf@oracle.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Tony Luck <tony.luck@gmail.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 3/11/19 7:51 PM, Martin K. Petersen wrote:
> 
> Tony,
> 
>> arch/ia64/hp/sim/simscsi.c: In function 'simscsi_interrupt':
>> arch/ia64/hp/sim/simscsi.c:108:51: error: 'struct scsi_cmnd' has no
>> member named 'serial_number'
> 
> I asked Hannes to fix this but he's been quiet for a few days. I guess
> I'll clean it up...
> 
Sorry. I'll send a patch shortly.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.com			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
