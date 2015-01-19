From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: [PATCHv2] libata: fixup oops in ata_eh_link_report()
Date: Mon, 19 Jan 2015 20:26:15 +0300
Message-ID: <54BD3E37.8060306@cogentembedded.com>
References: <1421682938-14073-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lb0-f173.google.com ([209.85.217.173]:61925 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475AbbASR0U (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Jan 2015 12:26:20 -0500
Received: by mail-lb0-f173.google.com with SMTP id p9so6094563lbv.4
        for <linux-scsi@vger.kernel.org>; Mon, 19 Jan 2015 09:26:19 -0800 (PST)
In-Reply-To: <1421682938-14073-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Tejun Heo <tj@kernel.org>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

Hello.

On 01/19/2015 06:55 PM, Hannes Reinecke wrote:

> We should only try to evaluate the cdb if this is an ATAPI
> device, for any other device the 'cdb' field and the cdb_len
> has no meaning.

> Fixes: cbba5b0ee4c6c2fc8b78a21d0900099d480cf2e9

    According to Documentation/SubmittingPatches, 12 digits is enough and, 
more importantly, that commit's summary line needs to be specified enclosed in 
parens and double quotes.

> Reported-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> Reviewed-by: Tejun Heo <tj@kernel.org>
> Tested-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

MBR, Sergei

