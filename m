From: "Nikanth K" <nikanth@gmail.com>
Subject: Re: [dm-devel] [PATCH 13/13] dm-mpath: convert to request-based
Date: Fri, 24 Oct 2008 13:25:33 +0530
Message-ID: <807b3a220810240055g1dfa4deam3f6a90d6c58aac32@mail.gmail.com>
References: <20080912.103814.74754581.k-ueda@ct.jp.nec.com>
	 <20080912.104727.38325381.k-ueda@ct.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.28]:15882 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346AbYJXHze (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Oct 2008 03:55:34 -0400
Received: by yx-out-2324.google.com with SMTP id 8so253423yxm.1
        for <linux-scsi@vger.kernel.org>; Fri, 24 Oct 2008 00:55:33 -0700 (PDT)
In-Reply-To: <20080912.104727.38325381.k-ueda@ct.jp.nec.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: jens.axboe@oracle.com, agk@redhat.com, James.Bottomley@hansenpartnership.com, j-nomura@ce.jp.nec.com, k-ueda@ct.jp.nec.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Nikanth Karthikesan <knikanth@suse.de>

On Fri, Sep 12, 2008 at 8:17 PM, Kiyoshi Ueda <k-ueda@ct.jp.nec.com> wrote:
> This patch converts dm-multipath target to request-based from bio-based.
>

Can we keep both the bio-based as well as request-based dm-multipath?

Thanks
Nikanth Karthikesan
