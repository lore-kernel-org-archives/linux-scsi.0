From: Willem Riede <wriede@riede.org>
Subject: Re: [PATCH] switch scsi upper driver probing to the driver model
Date: Sat, 17 May 2003 08:52:42 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030517125242.GG1480@linnie.riede.org>
References: <20030516182039.A7369@lst.de> <3EC5B3B8.9020308@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pcp02781107pcs.eatntn01.nj.comcast.net ([68.85.61.149]:15600
	"EHLO linnie.riede.org") by vger.kernel.org with ESMTP
	id S261437AbTEQMhg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 17 May 2003 08:37:36 -0400
Received: from linnie.riede.org (localhost.localdomain [127.0.0.1])
	by linnie.riede.org (8.12.8/8.12.8) with ESMTP id h4HCqgY8003961
	for <linux-scsi@vger.kernel.org>; Sat, 17 May 2003 08:52:42 -0400
Content-Disposition: inline
In-Reply-To: <3EC5B3B8.9020308@torque.net>; from dougg@torque.net on Fri, May 16, 2003 at 23:59:52 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On 2003.05.16 23:59, Douglas Gilbert wrote:
> Christoph,
> This patch would have some interesting side effects:
>   - no generic interface (apart from SCSI_IOCTL_SEND_COMMAND)
>     for tape devices (st and osst). While the maintainers of
>     st and osst might like this, not all the user apps would :-)

I would certainly like that sg access could not "interfere" with
osst while it is in control, but there would obviously have to be
a way to assign individual devices to specific drivers (as in tape1
is handled by st and tape2 by sg). And that would have to be dynamic
(as in I did a backup on tape1 with osst and now I want to tinker
with another tape using sg). Such mechanism doesn't exist, I think.

Thanks, Willem Riede.
