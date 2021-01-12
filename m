Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54F48C433E6
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 17:47:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 20B4E23121
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 17:47:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390101AbhALRq5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Jan 2021 12:46:57 -0500
Received: from smtprelay0162.hostedemail.com ([216.40.44.162]:49248 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2391624AbhALRqy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 12 Jan 2021 12:46:54 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay07.hostedemail.com (Postfix) with ESMTP id D740C181D304D;
        Tue, 12 Jan 2021 17:46:12 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: body58_371324127517
X-Filterd-Recvd-Size: 1714
Received: from [192.168.1.159] (unknown [47.151.137.21])
        (Authenticated sender: joe@perches.com)
        by omf10.hostedemail.com (Postfix) with ESMTPA;
        Tue, 12 Jan 2021 17:46:11 +0000 (UTC)
Message-ID: <60398acb9f26e60e3c1d6ab9c2d8bab4a89f2a91.camel@perches.com>
Subject: Re: [PATCH] scsi: mpt3sas: Simplify _base_display_OEMs_branding
From:   Joe Perches <joe@perches.com>
To:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     "MPT-FusionLinux.pdl@broadcom.com" <MPT-FusionLinux.pdl@broadcom.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date:   Tue, 12 Jan 2021 09:46:10 -0800
In-Reply-To: <DM5PR0401MB3591D23001DAC0AFB4F11D589BAA0@DM5PR0401MB3591.namprd04.prod.outlook.com>
References: <b4a0b8c97a95f56c64532eff83289831449e2b0d.camel@perches.com>
         <DM5PR0401MB3591D23001DAC0AFB4F11D589BAA0@DM5PR0401MB3591.namprd04.prod.outlook.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2021-01-12 at 17:40 +0000, Johannes Thumshirn wrote:
> On 12/01/2021 18:38, Joe Perches wrote:
> >  static void
> >  _base_display_OEMs_branding(struct MPT3SAS_ADAPTER *ioc)
> >  {
> > +	const char *b = NULL;	/* brand */
> > +	const char *v = NULL;	/* vendor */
> 
> Any reason you didn't spell out brand and vendor as the variable names?

80 column lines.


