From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Add proper module ID tables to Adaptec aic7[9x]xx drivers
Date: Thu, 7 Oct 2004 21:47:26 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041007214726.A17483@infradead.org>
References: <linux.scsi.20040621161047.GD16453@master.mivlgu.local> <41644BD5.7030807@tls.msk.ru> <20041006202543.GA22794@wotan.suse.de> <4165862E.1040904@adaptec.com> <4165950C.509@tls.msk.ru> <41659D30.7050705@adaptec.com> <20041007213612.A17286@infradead.org> <4165AA1A.1020708@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from baythorne.infradead.org ([81.187.226.107]:40201 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S268206AbUJGUrb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Oct 2004 16:47:31 -0400
Content-Disposition: inline
In-Reply-To: <4165AA1A.1020708@adaptec.com>; from luben_tuikov@adaptec.com on Thu, Oct 07, 2004 at 04:42:02PM -0400
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: Michael Tokarev <mjt@tls.msk.ru>, linux-scsi@vger.kernel.org

On Thu, Oct 07, 2004 at 04:42:02PM -0400, Luben Tuikov wrote:
> Ah, ok -- I was wondering.
> 
> Well, it's not as easy as dumping the list into a table.
> Let me try to come up with something here.

I think best would be to kill all subvendor/subdevice id matching
so we can just live with the generic ids.  This would simplify things
a lot if Adaptec doesn't plan to introduce random incompatiblities
for devices only differing in subvendor/subdevice id.

