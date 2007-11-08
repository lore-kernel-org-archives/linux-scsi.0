From: Benny Halevy <bhalevy@panasas.com>
Subject: Re: [PATCH 1/3] scsi_tgt_lib: Use scsi_init_io instead of scsi_alloc_sgtable
Date: Thu, 08 Nov 2007 10:32:56 +0200
Message-ID: <4732C9B8.6050204@panasas.com>
References: <4730ACAA.2060007@panasas.com>	<4730AF73.7010009@panasas.com> <20071108121321F.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sa10.bezeqint.net ([192.115.104.24]:52944 "EHLO
	sa10.bezeqint.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081AbXKHIdI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Nov 2007 03:33:08 -0500
In-Reply-To: <20071108121321F.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: bharrosh@panasas.com, James.Bottomley@SteelEye.com, michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org, pw@osc.edu

On Nov. 08, 2007, 5:13 +0200, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> On Tue, 06 Nov 2007 20:16:19 +0200
> Boaz Harrosh <bharrosh@panasas.com> wrote:
> 
>>   - If we export scsi_init_io()/scsi_release_buffers() instead of
>>     scsi_{alloc,free}_sgtable() from scsi_lib than tgt code is
>>     much more insulated from scsi_lib changes. As a bonus it will
>>     also gain bidi capability when it comes.
>>
>> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
> 
> Looks good for me except for this:
> 
> ./scripts/checkpatch.pl ~/Mail/kernel/scsi/28814
> ERROR: use tabs not spaces
> #101: FILE: drivers/scsi/scsi_lib.c:741:
> +                                              gfp_t gfp_mask)$

Come on Tomo, tabs should be used for nesting, not for decoration.
This way no matter what's your tab expansion setup is the
code will look correct and will make sense.  The number of space
characters in this case is equal to the number of characters in the
line above and with fixed-width fonts the line will be indented
just as you wanted.

The bottom line is that you should indent with as many tabs as your
nesting level, where all statements will begin, and from there on
use space characters.

For example:

{
	if (very_long_expression &&
	    it_needs_to_be_broken_into_several_lines)
		return a_very_long_result +
		       the_remainder_of_it_that_spilled_off +
		       to_the_next_lines;

	return printk("just my %d cents\n",
	              2);
}

Benny

> 
> total: 1 errors, 0 warnings, 144 lines checked

