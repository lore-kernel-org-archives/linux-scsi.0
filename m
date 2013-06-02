From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH v3 0/6] scsi_debug: bug fixes and cleanups for data integrity
 support
Date: Sun, 02 Jun 2013 13:01:57 -0400
Message-ID: <51AB7A85.8060406@interlog.com>
References: <1369555282-17864-1-git-send-email-akinobu.mita@gmail.com> <51A5057F.9030703@interlog.com> <yq1k3mi3nby.fsf@sermon.lab.mkp.net> <CAC5umyiW02vB-bbhCic=zU8CxaQY-AebQ0PCj1eTCifAUHortg@mail.gmail.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:33056 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754354Ab3FBRCI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 2 Jun 2013 13:02:08 -0400
In-Reply-To: <CAC5umyiW02vB-bbhCic=zU8CxaQY-AebQ0PCj1eTCifAUHortg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>

On 13-06-01 10:51 PM, Akinobu Mita wrote:
> 2013/5/29 Martin K. Petersen <martin.petersen@oracle.com>:
>> I have some patches pending as part of my next DIF/DIX update that makes
>> some of these things more palatable at the block/SCSI level. Akinobu
>> voiced interest in finishing the scsi_debug work on top of my code.
>
> Yes.  I'm interested in that work.  Before I start working on it, I would
> like to fix the problems which I found recently with virtual_gb option in
> scsi_debug.  Because the change is not small and may touch the DIX/DIF
> support code, too.
>
> So Martin and Douglas, can I have your ACKs on this patch series for now?

Done.

Just doing some debugging using scsi_debug and noticed
that 'blockdev --rereadpt /dev/sdb' causes a SCSI
REPORT SUPPORTED OPERATION CODES command to be issued.
Perhaps we could add that one (and ... SUPPORTED TMFs) to
scsi_debug's code.

I was also testing setting the SWP bit in the Control
mode page and that works, even though that field is
marked as 'changeable=n'. Since scsi_debug allows all
fields in that page to be changed, perhaps they could
all be marked as changeable.

Doug Gilbert


