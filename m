From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv2 2/5] scsi: make eh_eflags persistent
Date: Tue, 28 Feb 2017 13:09:29 +0100
Message-ID: <4611b1aa-a56d-4468-609d-dedbce31567e@suse.de>
References: <1487779650-1338-1-git-send-email-hare@suse.de>
 <1487779650-1338-3-git-send-email-hare@suse.de>
 <1488233711.2597.5.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:32987 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752200AbdB1MJc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 28 Feb 2017 07:09:32 -0500
In-Reply-To: <1488233711.2597.5.camel@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "hch@lst.de" <hch@lst.de>, "james.bottomley@hansenpartnership.com" <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "jth@kernel.org" <jth@kernel.org>

On 02/27/2017 11:15 PM, Bart Van Assche wrote:
> On Wed, 2017-02-22 at 17:07 +0100, Hannes Reinecke wrote:
>> To detect if a failed command has been retried we must not
>> clear scmd->eh_eflags when EH finishes.
>> The flag should be persistent throughout the lifetime
>> of the command.
> 
> Hello Hannes,
> 
> Is it on purpose that this patch does not remove the following statement from
> drivers/scsi/libsas/sas_scsi_host.c?
> 
> 		cmd->eh_eflags = 0;
> 
Oh, yes, you are right.

Will be fixing it up.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
