From: Michael Heinz <mheinz@infiniconsys.com>
Subject: Re: HBA switching devices online status...
Date: Tue, 16 Apr 2002 09:22:41 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3CBC25A1.9020302@infiniconsys.com>
References: <08628CA53C6CBA4ABAFB9E808A5214CB0C4D1F@mercury.infiniconsys.com> <3CBC225F.D75E55B4@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: linux-scsi@vger.kernel.org

Douglas Gilbert wrote:

>
>There is nothing stopping your HBA driver from setting the
>online flag in the Scsi_device structure.
>
>Doug Gilbert
>
Doug,

Thanks - my main concern was that non of the drivers in drivers/scsi 
actually do that - I was worried that that meant setting the flag was a 
Bad Thing. :-P

-- 
knock knock.

Michael Heinz <mheinz@infiniconsys.com>



