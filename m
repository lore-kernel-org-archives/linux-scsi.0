From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 0/9] target: Add support for COMPARE_AND_WRITE (VAAI)
 emulation
Date: Tue, 20 Aug 2013 14:53:08 -0700
Message-ID: <1377035588.32763.7.camel@haakon3.risingtidesystems.com>
References: <1377029280-19144-1-git-send-email-nab@daterainc.com>
	 <20130820212912.GA9483@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:58809 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246Ab3HTVqV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Aug 2013 17:46:21 -0400
In-Reply-To: <20130820212912.GA9483@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Martin Petersen <martin.petersen@oracle.com>, Chris Mason <chris.mason@fusionio.com>, James Bottomley <JBottomley@Parallels.com>

On Tue, 2013-08-20 at 23:29 +0200, Christoph Hellwig wrote:
> On Tue, Aug 20, 2013 at 08:07:51PM +0000, Nicholas A. Bellinger wrote:
> > 
> > It's also currently lacking the necessary sychronization between I/O
> > submission of COMPARE_AND_WRITE verify instance and write instance
> > user data, which is still being worked on in order to avoid additional
> > overhead in the main I/O fast path.
> 
> I don't think merging such a non-conforming implementation makes any sense.
> 

Yes, I don't intend to merge anything that's not fully functional.

The idea was to get review going on these pieces first.  I'll be posting
an PATCH-v2 to complete the implementation over the next days.

> Also for a complex command like this with all it's race potential I would
> really like to see some test cases to go along with it.
> 

Yes, Eric @ PureStorage has a sg_compare_write that I'm using to test
this.  It's probably about time that this be included in upstream
sg3-utils too..

--nab

