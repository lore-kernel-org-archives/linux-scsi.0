From: "Stephen Bates" <sbates@raithlin.com>
Subject: Re: [LSF/MM TOPIC][LSF/MM ATTEND] NAPI polling for block drivers
Date: Wed, 11 Jan 2017 22:56:12 -0600
Message-ID: <466066478645ecdc414e0d5de4178c41.squirrel@webmail.raithlin.com>
References: <20170111134312.GH6286@linux-x5ow.site>
    <cc00cc1f-17d7-105e-ef2c-61791b7cc676@kernel.dk>
    <43b3038b57ed5c00a73ebc5457d048d5.squirrel@webmail.raithlin.com>
    <43b42605-0c97-ca33-2e39-5ec58b441bcc@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gateway22.websitewelcome.com ([192.185.47.168]:51845 "EHLO
        gateway22.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750698AbdALFo5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 12 Jan 2017 00:44:57 -0500
Received: from cm1.websitewelcome.com (cm.websitewelcome.com [192.185.0.102])
        by gateway22.websitewelcome.com (Postfix) with ESMTP id 562091461D
        for <linux-scsi@vger.kernel.org>; Wed, 11 Jan 2017 22:56:14 -0600 (CST)
In-Reply-To: <43b42605-0c97-ca33-2e39-5ec58b441bcc@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Johannes Thumshirn <jthumshirn@suse.de>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, Christoph Hellwig <hch@infradead.org>, Sagi Grimberg <sagi@grimberg.me>, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, Keith Busch <keith.busch@intel.com>

>
> This is a separate topic. The initial proposal is for polling for
> interrupt mitigation, you are talking about polling in the context of
> polling for completion of an IO.
>
> We can definitely talk about this form of polling as well, but it should
> be a separate topic and probably proposed independently.
>
> --
> Jens Axboe
>
>

Jens

Oh thanks for the clarification. I will propose this as a separate topic.

Thanks

Stephen
