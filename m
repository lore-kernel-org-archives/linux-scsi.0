From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: Re: [PATCH 02/41] scsi: NCR5380: Mark expected switch fall-through
Date: Wed, 28 Nov 2018 07:47:05 -0600
Message-ID: <304bd094-7079-3a90-4901-9c86833d49e2@embeddedor.com>
References: <cover.1543374820.git.gustavo@embeddedor.com>
 <8b4ef418aa7803199954100fd89717f38d61ae06.1543374820.git.gustavo@embeddedor.com>
 <0caad885-94ad-9226-fbf1-996b5d465473@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <0caad885-94ad-9226-fbf1-996b5d465473@gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Michael Schmitz <schmitzmic@gmail.com>, Finn Thain <fthain@telegraphics.com.au>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Michael,

On 11/28/18 2:22 AM, Michael Schmitz wrote:

> I believe the 'if we get something weird' comment block relates to the
> default branch of the switch, _not_ the fall through from the case above
> (extended message received that we end up rejecting). Ordering the
> comments like you did just for GCC's sake is misleading.
> 
> The comment block should perhaps be moved after the default label. And
> it would be nice if the reason for the fall through could be retained in
> the comment.
> 

Oh Okay. I'll do that.

Thanks for the feedback.
--
Gustavo
