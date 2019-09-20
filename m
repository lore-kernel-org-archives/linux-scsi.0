Return-Path: <SRS0=xi/P=XP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8815DC49ED7
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Sep 2019 13:41:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5F2AC20717
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Sep 2019 13:41:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728002AbfITNlW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Sep 2019 09:41:22 -0400
Received: from wind.enjellic.com ([76.10.64.91]:43266 "EHLO wind.enjellic.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726924AbfITNlW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 20 Sep 2019 09:41:22 -0400
Received: from wind.enjellic.com (localhost [127.0.0.1])
        by wind.enjellic.com (8.15.2/8.15.2) with ESMTP id x8KDfFbW025206;
        Fri, 20 Sep 2019 08:41:15 -0500
Received: (from greg@localhost)
        by wind.enjellic.com (8.15.2/8.15.2/Submit) id x8KDfE8L025205;
        Fri, 20 Sep 2019 08:41:14 -0500
Date:   Fri, 20 Sep 2019 08:41:14 -0500
From:   "Dr. G.W. Wettstein" <greg@wind.enjellic.com>
Message-Id: <201909201341.x8KDfE8L025205@wind.enjellic.com>
In-Reply-To: Himanshu Madhani <hmadhani@marvell.com>
       "Re: [EXT] SRR response handling." (Sep 16,  4:14pm)
Reply-To: greg@enjellic.com
X-Mailer: Mail User's Shell (7.2.6-ESD1.0 03/31/2012)
To:     Himanshu Madhani <hmadhani@marvell.com>,
        Quinn Tran <qutran@marvell.com>
Subject: Re: [EXT] SRR response handling.
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.2.3 (wind.enjellic.com [127.0.0.1]); Fri, 20 Sep 2019 08:41:15 -0500 (CDT)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sep 16,  4:14pm, Himanshu Madhani wrote:
} Subject: Re: [EXT] SRR response handling.

> Hello Dr Greg, 

Good morning Himanshu, I hope your week has gone well.

>> We are looking forward to your reflections on the expected behavior of
>> the initiators if a target doesn't process the SRR.

> Still waiting on internal update before I respond with more
> details. Thanks for the patience.

Very good, I was just going to send you a note so your timing on this
was good.

We are still holding geographically dispersed mirrors open until we
can get a better understanding of what to expect from this situation.

We are also intrigued, from a technical perspective, since we may be
one of the few sites that can actually generate this phenomenon.

> - Himanshu

Thanks for taking the time out of your schedule to update us, we will
stand by for further information from your teams.

Best wishes for a pleasant weekend.

Dr. Greg

}-- End of excerpt from Himanshu Madhani

As always,
Dr. G.W. Wettstein, Ph.D.   Enjellic Systems Development, LLC.
4206 N. 19th Ave.           Specializing in information infra-structure
Fargo, ND  58102            development.
PH: 701-281-1686            EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"For future reference - don't anybody else try to send patches as vi
 scripts, please. Yes, it's manly, but let's face it, so is
 bungee-jumping with the cord tied to your testicles."
                                -- Linus Torvalds
                                   linux-kernel
