From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [Scst-devel] Integration of SCST in the mainstream Linux kernel
Date: Wed, 06 Feb 2008 10:29:31 +0900
Message-ID: <20080206102931C.fujita.tomonori@lab.ntt.co.jp>
References: <20080205223740L.tomof@acm.org>
	<C3CE56CB.57D4%matteo@rmnet.it>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama555.ecl.ntt.co.jp ([129.60.39.106]:41848 "EHLO
	tama555.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756031AbYBFB35 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Feb 2008 20:29:57 -0500
In-Reply-To: <C3CE56CB.57D4%matteo@rmnet.it>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: matteo@rmnet.it
Cc: tomof@acm.org, mangoo@wpkg.org, vst@vlnb.net, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, James.Bottomley@HansenPartnership.com, scst-devel@lists.sourceforge.net, akpm@linux-foundation.org, torvalds@linux-foundation.org, fujita.tomonori@lab.ntt.co.jp

On Tue, 05 Feb 2008 18:09:15 +0100
Matteo Tescione <matteo@rmnet.it> wrote:

> On 5-02-2008 14:38, "FUJITA Tomonori" <tomof@acm.org> wrote:
> 
> > On Tue, 05 Feb 2008 08:14:01 +0100
> > Tomasz Chmielewski <mangoo@wpkg.org> wrote:
> > 
> >> James Bottomley schrieb:
> >> 
> >>> These are both features being independently worked on, are they not?
> >>> Even if they weren't, the combination of the size of SCST in kernel plus
> >>> the problem of having to find a migration path for the current STGT
> >>> users still looks to me to involve the greater amount of work.
> >> 
> >> I don't want to be mean, but does anyone actually use STGT in
> >> production? Seriously?
> >> 
> >> In the latest development version of STGT, it's only possible to stop
> >> the tgtd target daemon using KILL / 9 signal - which also means all
> >> iSCSI initiator connections are corrupted when tgtd target daemon is
> >> started again (kernel upgrade, target daemon upgrade, server reboot etc.).
> > 
> > I don't know what "iSCSI initiator connections are corrupted"
> > mean. But if you reboot a server, how can an iSCSI target
> > implementation keep iSCSI tcp connections?
> > 
> > 
> >> Imagine you have to reboot all your NFS clients when you reboot your NFS
> >> server. Not only that - your data is probably corrupted, or at least the
> >> filesystem deserves checking...
> 
> Don't know if matters, but in my setup (iscsi on top of drbd+heartbeat)
> rebooting the primary server doesn't affect my iscsi traffic, SCST correctly
> manages stop/crash, by sending unit attention to clients on reconnect.
> Drbd+heartbeat correctly manages those things too.
> Still from an end-user POV, i was able to reboot/survive a crash only with
> SCST, IETD still has reconnect problems and STGT are even worst.

Please tell us on stgt-devel mailing list if you see problems. We will
try to fix them.

Thanks,
