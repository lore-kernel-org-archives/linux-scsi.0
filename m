From: Spencer Baugh <spencer.baugh@purestorage.com>
Subject: Re: [PATCH 1/2] target: remove unused lun_flags field from se_lun
Date: Tue, 21 Jul 2015 10:03:29 -0700
Message-ID: <87r3o1igta.fsf@ponos.purestorage.com>
References: <1437434990-13452-1-git-send-email-Spencer.baugh@purestorage.com> <20150721134042.GA30664@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:36046 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755714AbbGURDd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jul 2015 13:03:33 -0400
Received: by pachj5 with SMTP id hj5so123407239pac.3
        for <linux-scsi@vger.kernel.org>; Tue, 21 Jul 2015 10:03:33 -0700 (PDT)
In-Reply-To: <20150721134042.GA30664@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, "open list:TARGET SUBSYSTEM" <linux-scsi@vger.kernel.org>, "open list:TARGET SUBSYSTEM" <target-devel@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, Spencer Baugh <sbaugh@catern.com>, Chris Zankel <czankel@purestorage.com>

Christoph Hellwig <hch@infradead.org> writes:

> Looks good,
>
> but what's up with your From lines:
>
> On Mon, Jul 20, 2015 at 04:29:49PM -0700, Spencer Baugh wrote:
>> From: Spencer Baugh <sbaugh@catern.com>
>> 
>> From: Chris Zankel <czankel@purestorage.com>
>
> plus another address for you in the actual email From line.  Who
> did actually write this patch?

Sorry, ignore the first From: line; the correct one is
From: Chris Zankel <czankel@purestorage.com>
for both patches
