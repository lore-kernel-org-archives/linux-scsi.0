From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [RFC] scsi host sysfs support again [0/4]
Date: Thu, 08 May 2003 10:09:01 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3EB9A01D.3000300@torque.net>
References: <20030505083315.GB8416@beaverton.ibm.com> <1052238508.1819.42.camel@mulgrave> <20030506172312.GA1697@beaverton.ibm.com> <20030507231953.GS524@linnie.riede.org>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:52232 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S264407AbTEGXxo
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 May 2003 19:53:44 -0400
In-Reply-To: <20030507231953.GS524@linnie.riede.org>
List-Id: linux-scsi@vger.kernel.org
To: wrlk@riede.org
Cc: linux-scsi@vger.kernel.org

Willem Riede wrote:
> On 2003.05.06 13:23 Mike Anderson wrote:
> 
>>Other classes to consider:
>>	(scsi_tape or tape), (scsi_disk or disk), (scsi_gen).
>>I believe Greg KH mentioned something to me about why we would select
>>scsi_tape over tape, but I have forgot the reason.
>>
> 
> Would that be, because ide_tape could have different attributes?
> 
> In any case, there are some unique properties of onstream tapes that I
> would love to make available, so should osst define its own class?

Willem,
You already have the driver area in /sys/bus/scsi/drivers/osst .
Both the st and sg drivers have "atrtributes" in there. The
sd driver could do with some as well (e.g. default timeout,
number of retries).

Doug Gilbert


