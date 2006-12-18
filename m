From: Daniel Pittman <daniel@rimspace.net>
Subject: Re: [Fwd: AIC79XX abort -- hardware fault?]
Date: Mon, 18 Dec 2006 11:37:30 +1100
Message-ID: <87lkl6ghth.fsf@rimspace.net>
References: <1165940296.3257.35.camel@home-desk>
	<1165941570.5903.19.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:57986 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751011AbWLRBPP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 17 Dec 2006 20:15:15 -0500
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1Gw75r-0005J8-Ac
	for linux-scsi@vger.kernel.org; Mon, 18 Dec 2006 02:15:03 +0100
Received: from 203-217-29-45.perm.iinet.net.au ([203.217.29.45])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Mon, 18 Dec 2006 02:15:03 +0100
Received: from daniel by 203-217-29-45.perm.iinet.net.au with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Mon, 18 Dec 2006 02:15:03 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

James Bottomley <James.Bottomley@SteelEye.com> writes:
> On Tue, 2006-12-12 at 08:18 -0800, Sean Bruno wrote:
>> > G'day.  One of the machines I maintain is having real trouble with the
>> > AIC79XX HBA or the tape drive attached to it.  I believe this is a
>> > hardware fault, but I am not certain where the problem lies.
>> > 
>> > Normally I would blame the cable or, maybe, the tape drive, but the
>> > early stage of the fault and the reported SCSI driver state make me
>> > wonder if this is perhaps an HBA fault?
>
> The first question is what kernel version?  There was an aic79xx fix
> that went in just prior to 2.6.19 that might help with this.

    Linux genesys 2.6.18-028test007.1-ovz 

That is the 2.6.18 kernel (with RHES configuration) plus the OpenVZ
virtualization patches.  Unfortunately, that latter is in active use on
the system and limits the kernel versions that this could be seen with.

The OpenVZ support doesn't touch drivers, so I don't believe it is
responsible for the issue; we are certainly able to reproduce it with
OpenVZ inactive on the system.


Further reading in the Linux SCSI mailing list suggests that the
'slowcrc' command line option has resolved a similar looking issue for
another user, and that ramping down the speed for the device may also
help.

I am happy to try and test any appropriate patches back-ported to that
kernel version, but will schedule in trying the slowcrc option and
arrange to ramp down the bus speed some time soon as well.

Thanks for your help, and to Sean for moving this to a more correct
location.

Regards,
        Daniel
-- 
Digital Infrastructure Solutions -- making IT simple, stable and secure
Phone: 0401 155 707        email: contact@digital-infrastructure.com.au
                 http://digital-infrastructure.com.au/

