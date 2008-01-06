From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] tgt: Use scsi_init_io instead of scsi_alloc_sgtable
Date: Sun, 06 Jan 2008 19:08:54 +0200
Message-ID: <47810B26.1090709@panasas.com>
References: <47611977.5080702@panasas.com>  <47611B01.4010505@panasas.com> <1199487754.17877.99.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:43773 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753941AbYAFRKD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Jan 2008 12:10:03 -0500
In-Reply-To: <1199487754.17877.99.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>

On Sat, Jan 05 2008 at 1:02 +0200, James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> On Thu, 2007-12-13 at 13:44 +0200, Boaz Harrosh wrote:
>> - If we export scsi_init_io()/scsi_release_buffers() instead of
>>     scsi_{alloc,free}_sgtable() from scsi_lib than tgt code is
>>     much more insulated from scsi_lib changes. As a bonus it will
>>     also gain bidi capability when it comes.
>>
>> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
>> Acked-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> 
> I'm afraid the reversion of ->done removal broke the application of this
> yet again ... could you respin.
> 
> Thanks,
> 
> James
> 
It looks like the revert is to be reverted ;)
I have rebased, but should I wait a while to
see if they're needed?

Boaz

