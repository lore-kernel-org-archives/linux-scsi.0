From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Regression 4.13-rc1] Resume does not work on Lenovo X60t
Date: Tue, 29 Aug 2017 05:24:28 -0700
Message-ID: <20170829122428.GA29097@infradead.org>
References: <7032513a-7a28-5807-40d4-cb0f7005d513@molgen.mpg.de>
 <20170805093014.GA6511@infradead.org>
 <d30803d1861c9c105a35845759f58f8d@molgen.mpg.de>
 <9123f447-c06b-6a67-b380-90338eb2dde8@molgen.mpg.de>
 <20170821184115.GA16735@infradead.org>
 <3b5be305179828fd0e768c8ba9455851@molgen.mpg.de>
 <20170823114845.GB24217@infradead.org>
 <7e7e3ccf-f928-7fa5-1ea2-abbb94521cd7@molgen.mpg.de>
 <f415a9d7-25d4-77a6-b199-49b30ba989c0@molgen.mpg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:33127 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751582AbdH2MYb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Aug 2017 08:24:31 -0400
Content-Disposition: inline
In-Reply-To: <f415a9d7-25d4-77a6-b199-49b30ba989c0@molgen.mpg.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paul Menzel <pmenzel@molgen.mpg.de>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

On Tue, Aug 29, 2017 at 11:40:53AM +0200, Paul Menzel wrote:
> It looks like I was using blk-mq, as it was the default up to commit
> cbe7dfa26eee (Revert "scsi: default to scsi-mq"). So with Linux 4.13-rc7 and
> disabling blk-mq for SCSI, the system is functional again after resume.

Thanks for the confirmation Paul - I'll keep you on Cc when
implementing blќ runtime pm to make sure this issue doesn't reappear.
