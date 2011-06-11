From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: [PATCH] mptsas: Increase MPT_SAS_CAN_QUEUE
Date: Sun, 12 Jun 2011 08:22:35 +1200
Message-ID: <4DF3CE8B.3000707@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.sauce.co.nz ([210.48.49.72]:38525 "EHLO smtp.sauce.co.nz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751178Ab1FKUZM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 11 Jun 2011 16:25:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

  Darrick J. Wong wrote:

 > It seems that can_queue on mptsas controllers is clamped to 128 even 
  > though the hardware can have much larger queues.  Clamp to a higher
 > value to utilize the hardware more effectively--with a large number 
of > disks I see contention for queue slots, and with the higher clamp I
 > don't.
 >
 > Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
 > ---
 >
 > drivers/message/fusion/mptbase.h |    2 +-
 > 1 files changed, 1 insertions(+), 1 deletions(-)
 >
 > diff --git a/drivers/message/fusion/mptbase.h
 > b/drivers/message/fusion/mptbase.h
 > index fe90233..5d8c57e 100644
 > --- a/drivers/message/fusion/mptbase.h
 > +++ b/drivers/message/fusion/mptbase.h
 > @@ -159,7 +159,7 @@
 >   */
 >  #define MPT_FC_CAN_QUEUE	1024
 > #define MPT_SCSI_CAN_QUEUE	127
 > -#define MPT_SAS_CAN_QUEUE	127
 > +#define MPT_SAS_CAN_QUEUE	511
 >
 > /*
 >  * Set the MAX_SGE value based on user input.

Any comment from the LSI maintainers on this change?

Regards,

Richard
