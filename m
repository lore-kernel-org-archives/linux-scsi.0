From: Willem Riede <wrlk@riede.org>
Subject: Re: [RFC] scsi host sysfs support again [0/4]
Date: Wed, 7 May 2003 19:19:53 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030507231953.GS524@linnie.riede.org>
References: <20030505083315.GB8416@beaverton.ibm.com> <1052238508.1819.42.camel@mulgrave> <20030506172312.GA1697@beaverton.ibm.com>
Reply-To: wrlk@riede.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pcp02781107pcs.eatntn01.nj.comcast.net ([68.85.61.149]:46322
	"EHLO linnie.riede.org") by vger.kernel.org with ESMTP
	id S264334AbTEGXFY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 May 2003 19:05:24 -0400
Received: from linnie.riede.org (localhost.localdomain [127.0.0.1])
	by linnie.riede.org (8.12.8/8.12.8) with ESMTP id h47NJr3x015446
	for <linux-scsi@vger.kernel.org>; Wed, 7 May 2003 19:19:53 -0400
Content-Disposition: inline
In-Reply-To: <20030506172312.GA1697@beaverton.ibm.com>; from andmike@us.ibm.com on Tue, May 06, 2003 at 13:23:12 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On 2003.05.06 13:23 Mike Anderson wrote:
> 
> Other classes to consider:
> 	(scsi_tape or tape), (scsi_disk or disk), (scsi_gen).
> I believe Greg KH mentioned something to me about why we would select
> scsi_tape over tape, but I have forgot the reason.
> 
Would that be, because ide_tape could have different attributes?

In any case, there are some unique properties of onstream tapes that I
would love to make available, so should osst define its own class?

Thanks, Willem Riede.
