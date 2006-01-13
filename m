From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] mptsas: support basic hotplug
Date: Fri, 13 Jan 2006 10:19:07 -0600
Message-ID: <1137169147.3365.12.camel@mulgrave>
References: <20060113100905.GA26592@lst.de>
	 <1137167747.3365.6.camel@mulgrave>  <20060113160529.GA813@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:16853 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1422730AbWAMQTV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jan 2006 11:19:21 -0500
In-Reply-To: <20060113160529.GA813@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Eric.Moore@lsil.com, linux-scsi@vger.kernel.org

On Fri, 2006-01-13 at 17:05 +0100, Christoph Hellwig wrote:
> well, the scsi-misc tree doesn't have the mutex code yet, so it wouldn't
> compile if I did it that way.  I'll send a followon patch to convert it
> to use real mutexes ones scsi-misc has merged the latest linus tree.

Yes it does ... I updated it last night.  Could you pull it down again
and reroll this patch based on mutexes.

Thanks,

James


