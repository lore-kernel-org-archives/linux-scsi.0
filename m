From: "Bryn M. Reeves" <bmr@redhat.com>
Subject: Re: [PATCH] scsi_transport_fc: Make 'port_state' writeable
Date: Fri, 15 Mar 2013 12:37:11 +0000
Message-ID: <514315F7.4010101@redhat.com>
References: <1358262138-13378-1-git-send-email-hare@suse.de> <51421272.2000706@linux.vnet.ibm.com> <51430C4A.7090308@suse.de> <5143130F.4090702@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32285 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754226Ab3COMiM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Mar 2013 08:38:12 -0400
In-Reply-To: <5143130F.4090702@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Hannes Reinecke <hare@suse.de>, Steffen Maier <maier@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Chad Dupuis <chad.dupuis@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, James Smart <james.smart@emulex.com>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>

On 03/15/2013 12:24 PM, Bart Van Assche wrote:
> On 03/15/13 12:55, Hannes Reinecke wrote:
>> And the LLDD is forced into error recovery which'll take _ages_ as each
>> and every command send during error recovery will time out.
>
> Hello Hannes,
>
> I'm analyzing a related but not identical issue with SRP. It would help
> if you could tell with which LLDD you ran into this issue and with which
> values of fast_io_fail_tmo and dev_loss_tmo.

Most of the cases I've seen have involved lpfc (although I don't think 
it's in any way exclusive to that LLDD). Even with very low 
fast_io_fail_timeout/dev_loss_timeout (<5/10) the eh is busy for 10m or 
longer before IO fails and multipath is able to react to the problem.

Regards,
Bryn.

