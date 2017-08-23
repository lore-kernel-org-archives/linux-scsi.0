From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Regression 4.13-rc1] Resume does not work on Lenovo X60t
Date: Wed, 23 Aug 2017 04:48:45 -0700
Message-ID: <20170823114845.GB24217@infradead.org>
References: <7032513a-7a28-5807-40d4-cb0f7005d513@molgen.mpg.de>
 <20170805093014.GA6511@infradead.org>
 <d30803d1861c9c105a35845759f58f8d@molgen.mpg.de>
 <9123f447-c06b-6a67-b380-90338eb2dde8@molgen.mpg.de>
 <20170821184115.GA16735@infradead.org>
 <3b5be305179828fd0e768c8ba9455851@molgen.mpg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:33202 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753768AbdHWLsr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Aug 2017 07:48:47 -0400
Content-Disposition: inline
In-Reply-To: <3b5be305179828fd0e768c8ba9455851@molgen.mpg.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paul Menzel <pmenzel@molgen.mpg.de>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

Are you running with blk-mq enabled?  Also this never
occured with 4.12, right?  Were you also running with or
without blk-mq for scsi there?
