From: Martin Peschke3 <MPESCHKE@de.ibm.com>
Subject: Re: How to resurrect offlined SCSI devices?
Date: Wed, 26 May 2004 17:04:36 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OF8BCC3715.F39A8EBA-ONC1256EA0.00523377-C1256EA0.005351F7@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.de.ibm.com ([195.212.29.151]:39408 "EHLO
	mtagate2.de.ibm.com") by vger.kernel.org with ESMTP id S265599AbUEZPEl
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 May 2004 11:04:41 -0400
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>





James,

> Really, it isn't safe for a LLD to try to bring a device back online on
> its own without user intervention.

How does the user know that it is safe?
What if they just try to bring it online? What is happening in the worst
case?
My point is that users probably set the appropriate sys-attribute
in a "trial and error" fashion, if they think they have got a problem,
while an lldd might even know better.

Martin

James Bottomley <James.Bottomley@SteelEye.com> on 26/05/2004 16:45:46

To:    Martin Peschke3/Germany/IBM@IBMDE
cc:    SCSI Mailing List <linux-scsi@vger.kernel.org>
Subject:    Re: How to resurrect offlined SCSI devices?


On Wed, 2004-05-26 at 08:14, Martin Peschke3 wrote:
> Is there a SCSI mid layer interface that allows an lldd to get a
> SCSI devices back online?

actually

echo "running" > /sys/...<device path>.../state

will work from user land.

Really, it isn't safe for a LLD to try to bring a device back online on
its own without user intervention.

James





