From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [Lsf] [TOPIC] scsi-queue tree past and future
Date: Sat, 07 Mar 2015 05:10:36 +0200
Message-ID: <54FA6C2C.3050608@dev.mellanox.co.il>
References: <20150305133118.GA16575@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:43671 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753501AbbCGDKl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Mar 2015 22:10:41 -0500
Received: by wesu56 with SMTP id u56so62984995wes.10
        for <linux-scsi@vger.kernel.org>; Fri, 06 Mar 2015 19:10:40 -0800 (PST)
In-Reply-To: <20150305133118.GA16575@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, lsf@lists.linux-foundation.org, lsf-pc@lists.linux-foundation.org, linux-scsi@vger.kernel.org

On 3/5/2015 3:31 PM, Christoph Hellwig wrote:
> For about 8 month I've merged almost every scsi commit through the
> scsi-queue staging tree, and it seems to have worked out well enough.
>
> I've been too busy for the next cycle, so 4.1 will probably have to live
> without it.  I'd like to get feedback on how the tree worked for contributors
> and driver maintainers, and brainstorm how to move forward with it, preferably
> some form of real team maintainance that avoids single points of failure.

+1

I think this approach can make a lot of sense for other subsystems as
well.

Sagi.
