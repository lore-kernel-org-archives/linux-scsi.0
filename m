From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: RFC: sg driver addition: SG_FLAG_SHARED_MMAP_IO
Date: Thu, 22 Mar 2007 10:25:54 +0100
Message-ID: <1174555554.1158.168.camel@laptopd505.fenrus.org>
References: <4601EBD5.8040406@torque.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:34040 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965895AbXCVJ16 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Mar 2007 05:27:58 -0400
In-Reply-To: <4601EBD5.8040406@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org, pw@osc.edu, michaelc@cs.wisc.edu

On Wed, 2007-03-21 at 22:37 -0400, Douglas Gilbert wrote:
> 
> 
> In my experience mmap-ed IO using sg's reserve buffer mapped
> into the user space is faster than direct IO schemes. However
> one shortcoming is that if you try to copy between two devices
> using this technique then you end up with two separate mmap-ed
> buffers in the user space program. Then the user space program
> needs to copy between the two buffers which would defeat much
> of the advantage of the mmap-ed IO. You could (and sgm_dd in
> sg3_utils does) use mmap-ed IO on the read side and direct IO
> on the write side (or vice versa). 

on question; does your patch also make the block layer sg support this?
And if not, why not? (I would think sg and block layer sg should
converge not diverge)

(I would look but your attachement is gzipd for some reason)
-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

