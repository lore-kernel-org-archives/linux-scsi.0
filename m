From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [RFC] drop libsas task collector mode?
Date: Tue, 4 Nov 2014 11:06:25 -0800
Message-ID: <CAPcyv4jQoFioqheC79Ye-EJe-3b2-yfLKhkRc+SoGa0+9_a2yA@mail.gmail.com>
References: <20141104185821.GA10475@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:53919 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805AbaKDTG1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Nov 2014 14:06:27 -0500
Received: by mail-wi0-f172.google.com with SMTP id bs8so10328317wib.17
        for <linux-scsi@vger.kernel.org>; Tue, 04 Nov 2014 11:06:26 -0800 (PST)
In-Reply-To: <20141104185821.GA10475@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Xiangliang Yu <yuxiangl@marvell.com>

On Tue, Nov 4, 2014 at 10:58 AM, Christoph Hellwig <hch@infradead.org> wrote:
> The task collector mode in libsas implements internal queueing in
> libsas, which is somethign we usualy try to avoid, and doesn't seem
> to get much exposure as it's only supported as a non-default option
> in two drivers.
>
> If there's still interest in submitting multiple tasks in one go
> I'd be happy to wire up the blk-mq last parameter with a flag in
> the scsi command so that we could get a similar effect without all
> the overhead, but I'd need to have a signed up tester for it.

>From the isci perspective I don't care about task_collector going
away.  It's more "latency_injector" than anything else.
