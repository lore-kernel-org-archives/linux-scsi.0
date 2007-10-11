From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] Save some bytes in scsi_cmnd by rearranging members
Date: Thu, 11 Oct 2007 15:19:55 +0900
Message-ID: <20071011151955W.fujita.tomonori@lab.ntt.co.jp>
References: <20071008235010.GZ12049@parisc-linux.org>
	<470B4D13.8000705@panasas.com>
	<20071009180601.GI13842@parisc-linux.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama55.ecl.ntt.co.jp ([129.60.39.103]:53302 "EHLO
	tama55.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754162AbXJKGT4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Oct 2007 02:19:56 -0400
In-Reply-To: <20071009180601.GI13842@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: matthew@wil.cx
Cc: bharrosh@panasas.com, linux-scsi@vger.kernel.org

On Tue, 9 Oct 2007 12:06:01 -0600
Matthew Wilcox <matthew@wil.cx> wrote:

> On Tue, Oct 09, 2007 at 11:42:43AM +0200, Boaz Harrosh wrote:
> > Please don't do this patch for now. This is because of the 
> > soon to come scsi_data_buffer patch that rearages most of the members above
> > and puts them in a substructure. Maybe after the scsi_data_buffer patch you can
> > try to do this again.
> 
> BTW, how soon will this patch be coming?  If it'll be after 2.6.24,
> let's at least save some memory for people now.

I wait for Boaz's "Lots of the Accessors patches and !use_sg cleanup"
patchset to be merged. After that, I'll update and resend the
scsi_data_buffer patchset:

http://marc.info/?l=linux-scsi&m=118911556915876&w=2
