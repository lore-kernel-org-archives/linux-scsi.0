From: Matthias Prager <linux@matthiasprager.de>
Subject: Re: 'Device not ready' issue on mpt2sas since 3.1.10
Date: Thu, 26 Jul 2012 01:56:49 +0200
Message-ID: <501087C1.2020209@matthiasprager.de>
References: <4FFB8A86.7000009@farcaster.org>  <4FFCBA4C.4000502@farcaster.org> <4FFD6F3D.2030708@matthiasprager.de>  <4FFD8410.7050604@matthiasprager.de> <20120717180932.GB2878@google.com>  <5005BF7D.2050703@matthiasprager.de> <20120717200136.GC24336@google.com>  <500A9D7C.8080801@matthiasprager.de>  <20120722173146.GE5144@dhcp-172-17-108-109.mtv.corp.google.com>  <1343225953.12094.55.camel@dabdike> <20120725171723.GB32378@google.com> <1343246155.12094.59.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dd15408.kasserver.com ([85.13.136.168]:50034 "EHLO
	dd15408.kasserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770Ab2GYX5A (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Jul 2012 19:57:00 -0400
In-Reply-To: <1343246155.12094.59.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Tejun Heo <tj@kernel.org>, Robert Trace <maillist@farcaster.org>, linux-scsi@vger.kernel.org, Jens Axboe <jaxboe@fusionio.com>, Eric Moore <Eric.Moore@lsi.com>, Alan <alan@lxorguk.ukuu.org.uk>, "Darrick J. Wong" <djwong@us.ibm.com>, linux-ide@vger.kernel.org, Matthias Prager <linux@matthiasprager.de>

Hello James,

Am 25.07.2012 21:55, schrieb James Bottomley:>
> It looks like a hack like this might be needed.
>
> James
>

<SNIP>

I don't yet understand all the code but I'm following your discussion
with Tejun: I've set up a minimal vm running gentoo with a mpt2sas
driven controller in passthrough mode. I've applied your proposed patch
against the vanilla 3.5.0 kernel (which includes Tejun's commit), and
I'm happy to report the problem does seem to get fixed by it.
Well at least sending the sata drive in standby using 'hdparm -y' now
works (according to 'hdparm -C') without these nasty i/o errors on later
i/o. That is to say the drive wakes up again (e.g. from a 'fdisk -l
/dev/sda' command) and returns data.

--
Matthias
