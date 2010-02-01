From: Frans Pop <elendil@planet.nl>
Subject: Re: [PATCH 05/10] drivers/scsi/arcmsr: Fix continuation line formats
Date: Mon, 1 Feb 2010 19:02:31 +0100
Message-ID: <201002011902.33015.elendil@planet.nl>
References: <cover.1264967493.git.joe@perches.com> <1a318fa326c6ab2584b9d318bd1538e7f7debbdf.1264967499.git.joe@perches.com> <1a318fa326c6ab2584b9d318bd1538e7f7debbdf.1264967499.git.joe@perches.com> <1265044616.6910.15.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-To: <1265044616.6910.15.camel@mulgrave.site>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: joe@perches.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

James Bottomley wrote:
>> -                     printk(KERN_NOTICE "arcmsr%d: wait 'flush adapter cache' \
>> -                     timeout, retry count down = %d \n", acb->host->host_no, retry_count);
> 
> So I might personally dislike this style

The problem here is not style, but that the whitespace of the indentation
on the second line becomes part of the output!
That makes the code defective and is why Joe posted the patch series.

Cheers,
FJP
