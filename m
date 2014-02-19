From: Maurizio Lombardi <mlombard@redhat.com>
Subject: Re: [PATCH] st: use dev_printk() to avoid linebreaks in kernel messages.
Date: Wed, 19 Feb 2014 10:23:22 +0100
Message-ID: <5304780A.6020605@redhat.com>
References: <1392800681-5290-1-git-send-email-mlombard@redhat.com> <530474D2.4050504@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13074 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751375AbaBSJX4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Feb 2014 04:23:56 -0500
In-Reply-To: <530474D2.4050504@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Kai.Makisara@kolumbus.fi
Cc: linux-scsi@vger.kernel.org, jbottomley@parallels.com, kay@vrfy.org

Hi Hannes,

On 02/19/2014 10:09 AM, Hannes Reinecke wrote:
> Thanks for doing this.
> 
> I've actually a full patchset queued, converting all the stray
> 'printk' invocations in the SCSI stack to dev_printk() and friends.
> And moving to a per-device scsi_log_level :-)
> 
> So far I haven't posted them as I'm still waiting for feedback
> from my EVPD patchset.
> 
> But I can rebase them on top of that if you want to have a look at them.
> 


Are you talking about this patchset?

"scsi: avoid linebreaks in syslog output"
http://marc.info/?l=linux-scsi&m=135003083808290&w=2

If you have a more complete and up-to-date patchset in your queue it would be interesting to have a look at it.

Regards,
Maurizio Lombardi
