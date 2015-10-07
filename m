From: Junichi Nomura <j-nomura@ce.jp.nec.com>
Subject: Re: [REGRESSION v4.3] scsi_dh: use-after-free when removing scsi
 device
Date: Wed, 7 Oct 2015 05:55:54 +0000
Message-ID: <20151007055552.GA10877@xzibit.linux.bs1.fc.nec.co.jp>
References: <20150930003549.GA4857@xzibit.linux.bs1.fc.nec.co.jp>
 <20150930151857.GA26594@lst.de>
 <20151001005640.GA4821@xzibit.linux.bs1.fc.nec.co.jp>
 <20151001043844.GA8397@xzibit.linux.bs1.fc.nec.co.jp>
 <20151001052159.GA14247@lst.de>
 <20151001114021.GA15125@xzibit.linux.bs1.fc.nec.co.jp>
 <20151004074235.GA13912@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([210.143.35.51]:65055 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884AbbJGF4m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Oct 2015 01:56:42 -0400
In-Reply-To: <20151004074235.GA13912@lst.de>
Content-Language: ja-JP
Content-ID: <9449F03335A0FC4DB503EC849A620DAF@gisp.nec.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>

On 10/04/15 16:42, Christoph Hellwig wrote:
> Any chance you could share your various scripts in some way to that
> people doing multipath changes can run them to verify those changes?

Hi Christoph,

I've refined some pieces of test scripts which could be useful for
people and posted here:
  http://marc.info/?l=linux-scsi&m=144419652913948&w=2
  https://www.redhat.com/archives/dm-devel/2015-October/msg00034.html

The scripts are stress testing and expected to trigger crash/stall/
data corruption if you run long enough. Though it's not perfect I
hope this helps people do regression testing for dm-mpath related
code changes.

-- 
Jun'ichi Nomura, NEC Corporation
