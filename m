From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: Why is AHA152X_CS !64BIT?
Date: Mon, 30 Aug 2010 14:13:17 +0300
Message-ID: <4C7B924D.6030703@panasas.com>
References: <4C72D310.4040004@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from daytona.panasas.com ([67.152.220.89]:50599 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752058Ab0H3LNW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Aug 2010 07:13:22 -0400
In-Reply-To: <4C72D310.4040004@suse.cz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jiri Slaby <jslaby@suse.cz>
Cc: fischer@linux-buechse.de, linux-scsi@vger.kernel.org, Randy Dunlap <randy.dunlap@oracle.com>

On 08/23/2010 10:59 PM, Jiri Slaby wrote:
> Hi,
> 
> I see that the aha152x driver for pcmcia is marked as unsupported on
> 64bit. But I also see a patch [1] which removes the restriction based on
> user's testing in bugzilla [2].
> 
> Is there a reason why it would have to be marked as !64BIT? I'm asking
> because there is an opensuse user with this card who updated to 64-bit
> distro and lost this driver thereafter.
> 
> [1] http://kerneltrap.org/mailarchive/linux-scsi/2010/3/6/6832393
> [2] https://bugzilla.kernel.org/show_bug.cgi?id=14333
> 
> thanks,

If memory serves correctly, it might be that you need more then 4 Gbyte
of memory installed to exercise the bug, something about IO bouncing
addresses > 4G.

But don't believe me, I might be imagining things ;-)

Boaz
