From: Bart Van Assche <bart.vanassche@gmail.com>
Subject: Re: [PATCH 2.6.30] libsrp: fix memory leak in srp_ring_free()
Date: Sat, 5 Sep 2009 12:36:15 +0200
Message-ID: <e2e108260909050336p6b049953p7aa5e06602172804@mail.gmail.com>
References: <e2e108260908300336p777654bbw2f0b1eef9b6858c@mail.gmail.com>
	 <20090905182034M.fujita.tomonori@lab.ntt.co.jp>
	 <e2e108260909050234h6d5a391fh915ee85b4410f9a4@mail.gmail.com>
	 <20090905184328A.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:63344 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757168AbZIEKgN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Sep 2009 06:36:13 -0400
Received: by bwz19 with SMTP id 19so724956bwz.37
        for <linux-scsi@vger.kernel.org>; Sat, 05 Sep 2009 03:36:15 -0700 (PDT)
In-Reply-To: <20090905184328A.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James.Bottomley@suse.de, linux-scsi@vger.kernel.org, tomof@acm.org

On Sat, Sep 5, 2009 at 11:43 AM, FUJITA
Tomonori<fujita.tomonori@lab.ntt.co.jp> wrote:
> [...]
> You don't need to submit a patch to stable@kernel.org if you put 'Cc:
> stable@kernel.org' tag in a commit log; the patch will be sent to
> stable@kernel.org automatically after the the patch is merged into
> mainline.

I have just submitted a second revision of this patch with the 'Cc:
stable@kernel.org' added.

Bart.
