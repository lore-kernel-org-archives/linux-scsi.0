From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] a few storage topics
Date: Wed, 18 Jan 2012 15:39:20 -0800
Message-ID: <CABE8wwspDWNvBH97vp4_bq1Tuo9MELjQcGL613RxuuSMgLb7Pw@mail.gmail.com>
References: <CABE8wws67dn0fwhTCs_XqH0g_CxGuT+hPQH9cVFe1xx5t_O9Jw@mail.gmail.com>
	<20120117200609.GA7933@redhat.com>
	<20120117213648.GA9457@quack.suse.cz>
	<20120118225808.GA3074@tux1.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga07.intel.com ([143.182.124.22]:18826 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753130Ab2ARXjW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Jan 2012 18:39:22 -0500
In-Reply-To: <20120118225808.GA3074@tux1.beaverton.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: djwong@us.ibm.com
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, dm-devel@redhat.com, lsf-pc@lists.linux-foundation.org, linux-scsi@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>

On Wed, Jan 18, 2012 at 2:58 PM, Darrick J. Wong <djwong@us.ibm.com> wrote:
> Or possibly modify md-raid5 not to snapshot dirty pages prior to xor/write?
> (I never really bothered to find out if it really does this.)

It does.  ops_run_biodrain() copies from bio to the stripe cache
before performing xor.


--
Dan
