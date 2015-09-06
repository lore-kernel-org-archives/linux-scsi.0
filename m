From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH 0/1] Update scsi hosts to use idr for host number mgmt
Date: Sun, 6 Sep 2015 10:32:34 +0300
Message-ID: <55EBEC12.9030904@dev.mellanox.co.il>
References: <cover.1441412268.git.lduncan@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:33126 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888AbbIFHcm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Sep 2015 03:32:42 -0400
Received: by wiclk2 with SMTP id lk2so58448016wic.0
        for <linux-scsi@vger.kernel.org>; Sun, 06 Sep 2015 00:32:21 -0700 (PDT)
In-Reply-To: <cover.1441412268.git.lduncan@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Lee Duncan <lduncan@suse.com>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, hare@suse.com, jthumshirn@suse.de, JBottomley@Parallels.com

On 9/5/2015 11:44 PM, Lee Duncan wrote:
> This is an updated version of a patch I submitted a few days ago.
>
> The previous versions of this patch updated the scsi hosts module
> to use the ida helper routines to allocate host numbers, instead
> of using a simple integer.
>
> Based on a suggestion by Christoph Hellwig, I decided to use the
> idr helper routines instead of the ida set, since the idr functions
> can also associate a pointer with an index.

While we're at it, why not include sd index conversion?
