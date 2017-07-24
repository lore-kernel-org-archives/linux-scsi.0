From: Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH] aic7xxx: fix firmware build with O=path
Date: Mon, 24 Jul 2017 09:00:41 +0200
Message-ID: <5cf07bda-1bb8-4c71-58ad-d1af492b6c71@suse.com>
References: <20170719015834.19397-1-jakub.kicinski@netronome.com>
 <20170721115152.352ce0c9@cakuba.netronome.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.nue.novell.com ([195.135.221.5]:35169 "EHLO
        smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751793AbdGXHge (ORCPT
        <rfc822;groupwise-linux-scsi@vger.kernel.org:0:0>);
        Mon, 24 Jul 2017 03:36:34 -0400
In-Reply-To: <20170721115152.352ce0c9@cakuba.netronome.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jakub Kicinski <jakub.kicinski@netronome.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

On 07/21/2017 08:51 PM, Jakub Kicinski wrote:
> On Tue, 18 Jul 2017 18:58:34 -0700, Jakub Kicinski wrote:
>> Building firmware with O=path was apparently broken in aic7 for ever.
>> Message of the previous commit to the Makefile (from 2008) mentions
>> this unfortunate state of affairs already.  Fix this, mostly to make
>> randconfig builds more reliable.
>>
>> Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> 
> Gentle ping :)  Hannes, are you still maintaining aic7xxx?
> 
Yes, I do.

Patch looks reasonable; Kconfig is still black magic to me, though :-)

Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.com			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
