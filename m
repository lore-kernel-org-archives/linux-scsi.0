From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 1/4] [Linux/SCSI]: Change RECEIVE_CREDENTIAL
	to	VLC_SA_RECEIVE_CREDENTIAL
Date: Thu, 29 Jan 2009 15:31:35 -0800
Message-ID: <1233271895.6442.220.camel@haakon2.linux-iscsi.org>
References: <1233093749.6442.97.camel@haakon2.linux-iscsi.org>
	 <1233094236.6442.110.camel@haakon2.linux-iscsi.org>
	 <4981972A.2090801@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:33351 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752648AbZA2Xgx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Jan 2009 18:36:53 -0500
In-Reply-To: <4981972A.2090801@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>

On Thu, 2009-01-29 at 13:46 +0200, Boaz Harrosh wrote:
> Nicholas A. Bellinger wrote:
> > Hi James,
> > 
> > Let me know if you need a fresh respin of this patch..  According to
> > spc4r17 section D.3.5, VLC_SA_RECEIVE_CREDENTIAL is the only
> > VARIABLE_LENGTH_CMD defined Service ACtion..
> > 
> > --nab
> 
> Not accurate. See file include/scsi/osd_protocol.h in the scsi-misc
> git-tree master branch. The complete OSD command set is VARIABLE_LENGTH_CMD
> based. There must be others as well
> 

Ok, what I meant was:

>From searching spc4r17, VLC_SA_RECEIVE_CREDENTIAL (0x1800) is the only
SPC-4 defined VARIABLE_LENGTH_CMD defined Service Action in Table D.8.
>From SPC-4, the range 0x1800 -> 0x1FFF is reserved for SPC-4 defined
VARIABLE_LENGTH_CMD SAs.  

I see that OSD SAs for VARIABLE_LENGTH_CMD opcode are defined in range
0x8800 -> 0x8FFF, so does not it make sense to add the single VLC_SA_*
prefixed define above for range 0x1800 -> 0x1FFF in
include/scsi/scsi.h..?

Many thanks for your most valuable of time,

--nab


> Boaz
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

