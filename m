From: Michael Heinz <mheinz@infiniconsys.com>
Subject: Re: Task Sets in SCSI and Linux
Date: Wed, 8 May 2002 13:22:31 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <2D7BA26D-62A8-11D6-8C21-0003934B22FE@infiniconsys.com>
References: <200205081634.g48GYe304381@localhost.localdomain>
Mime-Version: 1.0 (Apple Message framework v481)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <200205081634.g48GYe304381@localhost.localdomain>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org


On Wednesday, May 8, 2002, at 12:34 PM, James Bottomley wrote:
>
>
> If by "take advantage of SCSI task sets" you mean use tagged tasks to 
> get
> multiple outstanding tasks on a logical unit, the answer is yes but it 
> depends
> on the low level driver implementation.
>
> James Bottomley
>
>
>

James,

You confused me with this - my testing with 2.4 seems to indicate that 
SCSI won't queue up more than one command per LUN (that is, it waits for 
one command to complete before issuing the next). How can I tell it to 
do otherwise? (It allows parallel commands, as long as they are going to 
different LUNs). I didn't see anything in the SHT to indicate otherwise.

