From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH 1/4] sas: add flag for locally attached PHYs
Date: Thu, 20 Oct 2005 12:16:23 -0400
Message-ID: <4357C2D7.80600@adaptec.com>
References: <91888D455306F94EBD4D168954A9457C048F0E9C@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:54177 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S932389AbVJTQQh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Oct 2005 12:16:37 -0400
In-Reply-To: <91888D455306F94EBD4D168954A9457C048F0E9C@nacos172.co.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Cc: Christoph Hellwig <hch@lst.de>, jejb@steeleye.com, linux-scsi@vger.kernel.org

On 10/20/05 11:45, Moore, Eric Dean wrote:
> 
> Thanks Luben - My concern is converting our SDI/CSMI ioctls
> into what is acceptable in mainstream kernel.  Agreed with Luben,
> all the expander data gathering, and configuration can be done 
> in user space, which is what is being done by the HP application
> folks which are currently using our internal CSMI enabled drivers.

Well, this is very good news.  This means less deployment time,
less code which needs to be changed, less code which needs
to go through testing and faster customer reach.

This should suggest Christoph "which way it should be done."

	Luben
-- 
http://linux.adaptec.com/sas/
http://www.adaptec.com/sas/

