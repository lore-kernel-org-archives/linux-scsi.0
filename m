From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH v2 06/13] lpfc: Add 64G link speed support
Date: Wed, 7 Feb 2018 16:40:59 +0100
Message-ID: <20180207154059.lzncsmrpoa7zlh53@linux-x5ow.site>
References: <20180207022851.11800-1-jsmart2021@gmail.com>
 <20180207022851.11800-7-jsmart2021@gmail.com>
 <20180207095846.gkh3oc3k5pnr6mlt@linux-x5ow.site>
 <b626516f-3569-59b7-4472-7668f96d0c46@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54945 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754031AbeBGPlA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 7 Feb 2018 10:41:00 -0500
Content-Disposition: inline
In-Reply-To: <b626516f-3569-59b7-4472-7668f96d0c46@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>
Cc: linux-scsi@vger.kernel.org, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

On Wed, Feb 07, 2018 at 07:38:39AM -0800, James Smart wrote:
> On 2/7/2018 1:58 AM, Johannes Thumshirn wrote:
> > On Tue, Feb 06, 2018 at 06:28:44PM -0800, James Smart wrote:
> > >   	lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
> > > -		"0469 lpfc_link_speed attribute cannot be set to %d, "
> > > -		"allowed values are ["LPFC_LINK_SPEED_STRING"]\n", val);
> > > +			"0469 lpfc_link_speed attribute cannot be set to %d, "
> > > +			"allowed values are ["LPFC_LINK_SPEED_STRING"]\n", val);
> > 
> > 	lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
> > 			"0469 lpfc_link_speed attribute cannot be set to %d, "
> > 			"allowed values are [%s]\n",
> > 			val, LPFC_LINK_SPEED_STRING);
> > 
> > And possible have the whole quoted string on one line for easier grepping.
> > checkplatch.pl should've told you that.
> > 
> 
> Checkpatch didn't say anything interesting. We consistently have line
> spanning as the lines are fairly verbose. Not an easy way to avoid that.
> 
> Regardless, no big deal.

The line-breaks make it non-trivial to grep for an error message. No big deal
and with lpfc having the numeric prefixes for prints this is actually not
needed.

What I mainly didn't like was the implicit pasting of the define instead of
%s. But no big deal as well.

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
