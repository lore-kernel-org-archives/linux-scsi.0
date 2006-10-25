From: "adam radford" <aradford@gmail.com>
Subject: Re: [GIT PATCH] SCSI fixes for 2.6.19-rc3
Date: Wed, 25 Oct 2006 14:49:28 -0700
Message-ID: <b1bc6a000610251449j34e5226crc606a1759b6aca19@mail.gmail.com>
References: <1161792760.3816.6.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.191]:61377 "EHLO
	nf-out-0910.google.com") by vger.kernel.org with ESMTP
	id S1751104AbWJYVta (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Oct 2006 17:49:30 -0400
Received: by nf-out-0910.google.com with SMTP id c2so730443nfe
        for <linux-scsi@vger.kernel.org>; Wed, 25 Oct 2006 14:49:29 -0700 (PDT)
In-Reply-To: <1161792760.3816.6.camel@mulgrave.il.steeleye.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On 10/25/06, James Bottomley <James.Bottomley@steeleye.com> wrote:
>  drivers/scsi/3w-9xxx.c                 |    5

James,

I NACK'd this patch in an earlier email and CC'd you on it:

"ioremap-balanced-with-iounmap-drivers-scsi-3w-9xxxc.patch"

Reason for NACK:  Whoever sprinkled iounmap() calls through various drivers put
                             this one in the wrong place, where
register accesses will occur
                             afterward while shutting down the card.

-Adam
