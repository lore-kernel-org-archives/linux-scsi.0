From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: [PATCH 0/9] scsi_data_buffer structure (in preparation for
 bidi)
Date: Sun, 9 Sep 2007 23:46:51 +0900
Message-ID: <20070909055725N.tomof@acm.org>
References: <46E3AE15.1060204@panasas.com>
	<20070909045734Y.tomof@acm.org>
	<46E3FE8B.8020401@panasas.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:33136 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756164AbXIIOr0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 9 Sep 2007 10:47:26 -0400
In-Reply-To: <46E3FE8B.8020401@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bharrosh@panasas.com
Cc: tomof@acm.org, linux-scsi@vger.kernel.org, jens.axboe@oracle.com, James.Bottomley@SteelEye.com, fujita.tomonori@lab.ntt.co.jp

On Sun, 09 Sep 2007 17:09:15 +0300
Boaz Harrosh <bharrosh@panasas.com> wrote:

> On Sun, Sep 09 2007 at 16:47 +0300, FUJITA Tomonori <tomof@acm.org> wrote:
> > On Sun, 09 Sep 2007 11:25:57 +0300
> > Boaz Harrosh <bharrosh@panasas.com> wrote:
> > 
> >> On Fri, Sep 07 2007 at 0:50 +0300, FUJITA Tomonori <tomof@acm.org> wrote:
> >>> This patchset, which I submitted before, adds a new data structure, 
> >>> scsi_data_buffer, including everything for data transfer:
> >>>
> >>> struct scsi_data_buffer { unsigned length; int resid; short sg_count;
> >>>  short __sg_count; struct scatterlist *sglist; };
> >>>
> >>> One scsi_data_buffer structure is embedded in struct scsi_cmnd for 
> >>> uni-directional transfer. All the members are just moved from 
> >>> scsi_cmnd structure to scsi_data_buffer structure. So nothing is
> >>> added to scsi_cmnd structure.
> >>>
> >>> After applying this patchset, llds must use the scsi data accessors.
> >>> This patchset includes some conversation patches (most of them are
> >>> patches that Boaz submitted before), however there is still some code
> >>> that is needed to be converted.
> >>>
> >>> Boaz, if you still have other conversation patches, please submit 
> >>> them.
> >>>
> >>> I suspect that nobody cares about some of unconverted llds, which
> >>> will be not compilable after this patchset. I'll fix ldds that people
> >>>  complain about.
> >>>
> >>> It's difficult to test this patchset in -mm via scsi-misc. Jens, 
> >>> please send this to -mm via the block tree.
> >> Sorry for the late response. Just am back from vacation.
> >>
> >> Tomo please hold with these patches a bit longer the
> >> Tree is not ready for it. 
> > 
> > Then we have no chance to merge scsi_data_buffer into 2.6.24.
> > 
> I hope to submit all/most of the work this week. If we miss the window
> for 2.6.24 than I'm very sorry for that. But I don't think we are 
> aloud to break USB storage subsystem.

I'll send patches for USB (in a 'search and replace' way) if you don't
soon. Except for USB, I suspect that nobody cares about most of the
unconverted drivers.
