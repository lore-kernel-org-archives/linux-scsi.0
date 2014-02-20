From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] st: use dev_printk() to avoid linebreaks in kernel messages.
Date: Thu, 20 Feb 2014 14:25:07 -0500
Message-ID: <yq1ob21k2ng.fsf@sermon.lab.mkp.net>
References: <1392800681-5290-1-git-send-email-mlombard@redhat.com>
	<530474D2.4050504@suse.de> <5304780A.6020605@redhat.com>
	<53047DA0.4030100@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:24421 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754880AbaBTTZ1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Feb 2014 14:25:27 -0500
In-Reply-To: <53047DA0.4030100@suse.de> (Hannes Reinecke's message of "Wed, 19
	Feb 2014 10:47:12 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Maurizio Lombardi <mlombard@redhat.com>, Kai.Makisara@kolumbus.fi, linux-scsi@vger.kernel.org, jbottomley@parallels.com, kay@vrfy.org

>>>>> "Hannes" == Hannes Reinecke <hare@suse.de> writes:

Hannes,

>> If you have a more complete and up-to-date patchset in your queue it
>> would be interesting to have a look at it.
>> 
Hannes> You can find the current development branch at

Hannes> git.kernel.org:/pub/scm/linux/kernel/git/hare/scsi-devel branch
Hannes> scsi-logging.v3

I like the printk cleanups and the more sensible sense printing. But why
perpetuate the crufty old SCSI logging stuff when we have SCSI tracing?

-- 
Martin K. Petersen	Oracle Linux Engineering
