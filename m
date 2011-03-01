From: Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: NEC ND-4550A problems reading DVD-R
Date: Tue, 01 Mar 2011 11:01:41 +0100
Message-ID: <m37hcjgnwa.fsf@intrepid.localdomain>
References: <m339n7g7tw.fsf@intrepid.localdomain>
	<20110301080153.GA26074@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20110301080153.GA26074@htj.dyndns.org> (Tejun Heo's message of
	"Tue, 1 Mar 2011 09:01:53 +0100")
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-ide@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Tejun Heo <tj@kernel.org> writes:

> I think that's determined by drivers/scsi/sr.h::SR_TIMEOUT which is
> hardcoded to be 30 seconds.  Maybe it's better to move it to use the
> block parameter.  Anyways, the drive actually takes longer than 30secs
> to recognize the media?

Yes, sometimes it takes e.g. 18 seconds, and sometimes it's 33 secs or
something alike. It's quite random.

Perhaps we should have a longer timeout only while mounting the media?

> Eeek, ugly.  Isn't there firmware update available for the drive?

1.09 is already the latest. It's a '2005 drive.

Thanks.
-- 
Krzysztof Halasa
