From: Lincoln Dale <ltd@cisco.com>
Subject: Re: What's the "right" qla2100 driver?
Date: Thu, 22 Jan 2004 11:40:49 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <5.1.0.14.2.20040122113841.03dc1008@171.71.163.14>
References: <F888C30C3021D411B9DA00B0D0209BE8038F9BD1@cvo-exchange.cvo.
 roguewave.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-4.cisco.com ([171.68.10.86]:56590 "EHLO
	sj-iport-4.cisco.com") by vger.kernel.org with ESMTP
	id S264278AbUAVAk5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Jan 2004 19:40:57 -0500
In-Reply-To: <F888C30C3021D411B9DA00B0D0209BE8038F9BD1@cvo-exchange.cvo.
 roguewave.com>
List-Id: linux-scsi@vger.kernel.org
To: Poul Petersen <petersp@roguewave.com>
Cc: linux-scsi@vger.kernel.org

At 11:32 AM 22/01/2004, Poul Petersen wrote:
>         I've got a Qlogic qla2100 card connected via copper to an array
>of 28 ~18GB disks. I'm trying to create two raid level 5 md devices with
>13disk+1spare each. What I'm experiencing is a lot of hangs and strange
>disk failures that appear to be related to the drivers for the 2100.
[..]
># cat /proc/mdstat | grep speed
>
>       [=>...................]  resync =  5.1% (904396/17671424)
>finish=7654.5min speed=35K/sec
>       [====>................]  resync = 22.1% (3919392/17671424)
>finish=34.8min speed=6577K/sec
>
>The driver seems to work, but the ability of the driver to balance requests
>between the two
>raid sets seems very poor. Watching the activity lights reflects the stats
>showed above: the
>second raid set blinks once or twice, then hangs for 5~10 seconds, blinks,
>hangs, etc.
>I haven't tried running with this driver much longer than the mkraid...

noone said that FC Arbitrated Loop provide FAIR arbitration between devices 
. . .

