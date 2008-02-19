From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: SCSI RAM driver
Date: Tue, 19 Feb 2008 22:46:57 +0900
Message-ID: <20080219224653G.tomof@acm.org>
References: <20080218063658.GF21012@parisc-linux.org>
	<20080219221442L.tomof@acm.org>
	<20080219133120.GA23001@parisc-linux.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:60307 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751603AbYBSNrF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Feb 2008 08:47:05 -0500
In-Reply-To: <20080219133120.GA23001@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: matthew@wil.cx
Cc: tomof@acm.org, linux-scsi@vger.kernel.org, kristen.c.accardi@intel.com, fujita.tomonori@lab.ntt.co.jp, dougg@torque.netfujita.tomonori@lab.ntt.co.jp

On Tue, 19 Feb 2008 06:31:20 -0700
Matthew Wilcox <matthew@wil.cx> wrote:

> On Tue, Feb 19, 2008 at 10:14:53PM +0900, FUJITA Tomonori wrote:
> > I see that two drivers have very different objectives but if we add
> > use_thread option to scsi_debug (we can do easily), it seems that
> > scsi_debug can provide all the features that scsi_ram does.
> 
> It's not just use_thread.  It's also discard_read/discard_write.

scsi_debug has a similar option, fake_rw, which discards both read and
write data.


> And scsi_ram has a different data storage model from scsi_debug --
> scsi_debug simulates an arbitrarily sized disc by wrapping around some
> small (virtually) contiguous allocation of pages; scsi_ram actually
> allocates the amount of ram that it's told to.  This can be solved with
> another module parameter, of course.

IIRC, if virtual_gb option is set to zero, scsi_debug allocates the
amount of ram that it's told to.


> I'm in no way opposed to merging the two; it's a question of whether
> Doug will mind me doing some surgery on his driver.
