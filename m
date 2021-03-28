Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F1A4C433E0
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Mar 2021 14:58:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 14F9361971
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Mar 2021 14:58:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231131AbhC1O6Z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 28 Mar 2021 10:58:25 -0400
Received: from netrider.rowland.org ([192.131.102.5]:33145 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S230526AbhC1O6Y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Mar 2021 10:58:24 -0400
Received: (qmail 902716 invoked by uid 1000); 28 Mar 2021 10:58:23 -0400
Date:   Sun, 28 Mar 2021 10:58:23 -0400
From:   Alan Stern <stern@rowland.harvard.edu>
To:     Martin Kepplinger <martin.kepplinger@puri.sm>
Cc:     bvanassche@acm.org, jejb@linux.ibm.com,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-pm@vger.kernel.org, martin.petersen@oracle.com
Subject: Re: [PATCH v3 0/4] scsi: add runtime PM workaround for SD cardreaders
Message-ID: <20210328145823.GA902609@rowland.harvard.edu>
References: <20210328102531.1114535-1-martin.kepplinger@puri.sm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210328102531.1114535-1-martin.kepplinger@puri.sm>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, Mar 28, 2021 at 12:25:27PM +0200, Martin Kepplinger wrote:
> hi,
> 
> In short: there are SD cardreaders that send MEDIA_CHANGED on
> (runtime) resume. We cannot use runtime PM with these devices as
> I/O always fails. I'd like to discuss a way to fix this
> or at least allow us to work around this problem:

In fact, as far as I know _all_ USB SD card readers send Media Changed 
notifications on resume.  Maybe there are some that don't, but I haven't 
heard of any.

Alan Stern
