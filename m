From: Andreas Herrmann <aherrmann@suse.com>
Subject: [LSF/MM TOPIC][LSF/MM ATTEND] blk-mq and I/O scheduling
Date: Fri, 26 Feb 2016 17:10:52 +0100
Message-ID: <20160226161052.GA4089@suselix.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.nue.novell.com ([195.135.221.5]:32998 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753896AbcBZQLX (ORCPT
	<rfc822;groupwise-linux-scsi@vger.kernel.org:0:0>);
	Fri, 26 Feb 2016 11:11:23 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: lsf-pc@lists.linuxfoundation.org
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org

Hi,

I'd like to participate in LSF/MM and would like to present/discuss
ideas for introducing I/O scheduling support to blk-mq.

Motiviation for this is to be able use scsi-mq even on systems that
have slow (spinning) devices attached to the SCSI stack.

I think the presentation/discussion should consist of the following

(1) short overview how blk-mq currently performs with spinning devices
    (in comparison to CFQ)

(2) information about my attempt to introduce per sw queue time-slice
    to blk-mq to mitigate the performance degradation with spinning
    devices (in comparison to CFQ)

(3) hopefully I can share information about working code for another
    approach to introduce I/O scheduling for blk-mq (which I am
    currently looking into)

(4) other ideas (e.g. toggle blk-mq per host and/or why we won't look
    into it)


Thanks,

Andreas
