From: Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCHv2] libsas: Check for completed commands before calling
 lldd_abort_task()
Date: Tue, 9 Jan 2018 10:30:45 +0100
Message-ID: <b1935687-4d39-3aca-1ee5-01dc513a8735@suse.com>
References: <1515413086-34256-1-git-send-email-hare@suse.de>
 <1515431496.3305.62.camel@debian.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.nue.novell.com ([195.135.221.5]:34542 "EHLO
        smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752590AbeAIJas (ORCPT
        <rfc822;groupwise-linux-scsi@vger.kernel.org:0:0>);
        Tue, 9 Jan 2018 04:30:48 -0500
In-Reply-To: <1515431496.3305.62.camel@debian.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Yves-Alexis Perez <corsac@debian.org>, Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org

On 01/08/2018 06:11 PM, Yves-Alexis Perez wrote:
> On Mon, 2018-01-08 at 13:04 +0100, Hannes Reinecke wrote:
>> The abort handler might be racing with command completion, so the
>> task might already be NULL by the time the abort handler is called.
> 
> Hi,
> 
> I tried the patch on top of 4.15-rc7 (and without the revert of 90965761). I
> don't have the NULL pointer deref anymore, but the box timeouts after SCSI
> init. It's not completely dead, but I don't have any meaningful log from the
> kernel.
> 
Can you try to boot the stock 4.15 kernel (without any patches) with
scsi_mod.scsi_logging_level=9411
on the kernel commandline and send me tha output?
I really would like to see which command fails.
THX.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.com			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
