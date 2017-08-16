From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv3 3/5] scsi_devinfo: Reformat blacklist flags
Date: Wed, 16 Aug 2017 07:56:34 +0200
Message-ID: <26d00cc6-93f7-1d99-7a22-e208594d264a@suse.de>
References: <1502461401-94630-1-git-send-email-hare@suse.de>
 <1502461401-94630-4-git-send-email-hare@suse.de>
 <1502837572.2259.17.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57461 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751070AbdHPF4g (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 16 Aug 2017 01:56:36 -0400
In-Reply-To: <1502837572.2259.17.camel@wdc.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "hch@lst.de" <hch@lst.de>, "james.bottomley@hansenpartnership.com" <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.com" <hare@suse.com>, "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>

On 08/16/2017 12:52 AM, Bart Van Assche wrote:
> On Fri, 2017-08-11 at 16:23 +0200, Hannes Reinecke wrote:
>> +typedef __u32 __bitwise sdev_bflags_t;
>> +
>> +/* Only scan LUN 0 */
>> +#define BLIST_NOLUN		((__force sdev_bflags_t)(1 << 0))
> 
> Hello Hannes,
> 
> Is the new typedef used anywhere outside the BLIST flag definitions?
> If not, how about skipping the introduction of a typedef and using
> u32 __bitwise directly?
> 
Yeah, can do.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
