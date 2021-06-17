Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DATE_IN_PAST_12_24,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 372FDC2B9F4
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Jun 2021 20:56:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C9A061059
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Jun 2021 20:56:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232676AbhFQU7C (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Jun 2021 16:59:02 -0400
Received: from smtprelay0204.hostedemail.com ([216.40.44.204]:54456 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231241AbhFQU7C (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 17 Jun 2021 16:59:02 -0400
Received: from omf18.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay07.hostedemail.com (Postfix) with ESMTP id BC68C181D341E;
        Thu, 17 Jun 2021 20:56:52 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf18.hostedemail.com (Postfix) with ESMTPA id 67AC22EBFA9;
        Thu, 17 Jun 2021 20:56:50 +0000 (UTC)
Message-ID: <d6c939f27ee67dda21562e4eb1573e6180ecef1c.camel@perches.com>
Subject: Re: Re: [PATCH] scsi: ufs: Add indent for code alignment
From:   Joe Perches <joe@perches.com>
To:     keosung.park@samsung.com, ALIM AKHTAR <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "adrian.hunter@intel.com" <adrian.hunter@intel.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "satyat@google.com" <satyat@google.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <2038148563.21623893584364.JavaMail.epsvc@epcpadp4>
References: <e0950e65c5e7f8f0db132cfd22bdd24ee27c63e7.camel@perches.com>
         <1891546521.01623299401994.JavaMail.epsvc@epcpadp3>
         <CGME20210610040731epcms2p7533bc62d13b82a0e86590f30ac4b6c30@epcms2p1>
         <2038148563.21623893584364.JavaMail.epsvc@epcpadp4>
Content-Type: text/plain; charset="ISO-8859-1"
MIME-Version: 1.0
Date:   Wed, 16 Jun 2021 20:35:26 -0700
User-Agent: Evolution 3.40.0-1 
Content-Transfer-Encoding: 8bit
X-Stat-Signature: z3xgzx8m9jjdsnu1s1ughpj8i4gd4pod
X-Rspamd-Server: rspamout04
X-Rspamd-Queue-Id: 67AC22EBFA9
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX19iIO6/WA0deVKmYeoqXnlVruH+W3b95WY=
X-HE-Tag: 1623963410-885665
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2021-06-17 at 10:28 +0900, Keoseong Park wrote:
> > On Thu, 2021-06-10 at 13:07 +0900, Keoseong Park wrote:
> > > Add indentation to return statement.
> > []
> > > diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> > []
> > > @@ -903,7 +903,7 @@ static inline bool
> > > ufshcd_is_intr_aggr_allowed(struct ufs_hba *hba)
> > >  	else
> > >  		return false;
> > >  #else
> > > -return true;
> > > +	return true;
> > >  #endif
> > >  }
> > >  
> > 
> > Perhaps a little refactoring instead:
> > ---
> > drivers/scsi/ufs/ufshcd.h | 12 ++++--------
> > 1 file changed, 4 insertions(+), 8 deletions(-)
> > 
> > diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> > index c98d540ac044d..ed89839476b3b 100644
> > --- a/drivers/scsi/ufs/ufshcd.h
> > +++ b/drivers/scsi/ufs/ufshcd.h
> > @@ -894,15 +894,11 @@ static inline bool
> > ufshcd_is_rpm_autosuspend_allowed(struct ufs_hba *hba)
> > static inline bool ufshcd_is_intr_aggr_allowed(struct ufs_hba *hba)
> > {
> > /* DWC UFS Core has the Interrupt aggregation feature but is not
> > detectable*/
> > -#ifndef CONFIG_SCSI_UFS_DWC
> > -	if ((hba->caps & UFSHCD_CAP_INTR_AGGR) &&
> > -	    !(hba->quirks & UFSHCD_QUIRK_BROKEN_INTR_AGGR))
> > +	if (IS_ENABLED(CONFIG_SCSI_UFS_DWC))
> > 		return true;
> > -	else
> > -		return false;
> > -#else
> > -return true;
> > -#endif
> > +
> > +	return (hba->caps & UFSHCD_CAP_INTR_AGGR) &&
> > +		!(hba->quirks & UFSHCD_QUIRK_BROKEN_INTR_AGGR);
> > }
> > 
> > static inline bool ufshcd_can_aggressive_pc(struct ufs_hba *hba)
> > 
> 
> Hello Joe,
> Thanks for your advice.
> As you mentioned, refactoring looks good.
> However, since the content does not match the title, can I submit a
> patch with a new title?

Yes of course.

