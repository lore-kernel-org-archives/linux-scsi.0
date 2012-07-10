From: Robert Trace <maillist@farcaster.org>
Subject: Re: 'Device not ready' issue on mpt2sas since 3.1.10
Date: Mon, 09 Jul 2012 21:56:39 -0400
Message-ID: <4FFB8BD7.4000904@farcaster.org>
References: <4FE454CA.6080007@matthiasprager.de> <4FFAED4F.3080100@matthiasprager.de> <4FFB32E5.1050109@farcaster.org> <20120709204513.GD25664@kernel.stglabs.ibm.com> <4FFB5A0F.30400@farcaster.org> <4FFB7575.4060603@matthiasprager.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from eris.farcaster.org ([75.127.72.104]:42476 "EHLO
	smtp.farcaster.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952Ab2GJB4l (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Jul 2012 21:56:41 -0400
In-Reply-To: <4FFB7575.4060603@matthiasprager.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthias Prager <linux@matthiasprager.de>
Cc: djwong@us.ibm.com, linux-scsi@vger.kernel.org

On 07/09/2012 08:21 PM, Matthias Prager wrote:
>
> I haven't checked the scsi logging side, but about the only commands
> that wake up the disks are 'smartctl -a /dev/sda' and 'sg_start'
> (smartcl maybe issuing a START UNIT command on it's own).

smartctl -a does appear to wake the disks.  The scsi log shows an
IDENTIFY and then several ATA passthrough commands (one of which takes
~10 seconds to complete).  So, I don't see an explicit START UNIT, but
one of those ATA commands which I didn't decode could certainly trigger
the wakeup.

-- Rob
