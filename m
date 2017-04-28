From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 2/3] scsi_dh_alua: Do not retry for unmapped device
Date: Fri, 28 Apr 2017 21:52:15 +0200
Message-ID: <1493409135.4507.16.camel@suse.com>
References: <20170428130626.32162-1-mwilck@suse.com>
         <20170428130626.32162-3-mwilck@suse.com>
         <1493404971.2767.15.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:58883 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1035424AbdD1TwY (ORCPT
        <rfc822;groupwise-linux-scsi@vger.kernel.org:0:0>);
        Fri, 28 Apr 2017 15:52:24 -0400
In-Reply-To: <1493404971.2767.15.camel@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>, "hare@suse.de" <hare@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "mauricfo@linux.vnet.ibm.com" <mauricfo@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hi Bart,

On Fri, 2017-04-28 at 18:42 +0000, Bart Van Assche wrote:
> On Fri, 2017-04-28 at 15:06 +0200, Martin Wilck wrote:
> > From: Hannes Reinecke <hare@suse.de>
> > 
> > If a device becomes unmapped on the target we should be returning
> > SCSI_DH_DEV_OFFLINED.
> > 
> > Signed-off-by: Hannes Reinecke <hare@suse.com>
> > Reviewed-by: Martin Wilck <mwilck@suse.com>
> 
> Hello Hannes and Martin,
> 
> Have you considered to add "Cc: stable" to this patch and other
> patches in
> this series?

Sorry, I forgot. But a v2 will be necessary anyway as it seems.

Regards
Martin

-- 
Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
