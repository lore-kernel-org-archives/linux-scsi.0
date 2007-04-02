From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: SMP pass through interface via bsg
Date: Mon, 02 Apr 2007 12:01:41 -0500
Message-ID: <1175533302.3680.31.camel@mulgrave.il.steeleye.com>
References: <20070402214325Y.fujita.tomonori@lab.ntt.co.jp>
	 <1175529721.3680.18.camel@mulgrave.il.steeleye.com>
	 <20070403012747O.fujita.tomonori@lab.ntt.co.jp>
	 <20070403014349E.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:59941 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933786AbXDBRC2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Apr 2007 13:02:28 -0400
In-Reply-To: <20070403014349E.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: hch@infradead.org, dougg@torque.net, James.Smart@Emulex.Com, jens.axboe@oracle.com, linux-scsi@vger.kernel.org

On Tue, 2007-04-03 at 01:43 +0900, FUJITA Tomonori wrote:
> OK. I found another bug in smp_test tool (sends bogus response buffer
> len to kernel). I've uploaded a new patch:
> 
> http://zaal.org/bsg/smp-test2.diff

That sort of works; you have a final bug in that the manufacturer info
response frame is 64 bytes, not 128 bytes, but with that corrected
everything goes through and I get the result back:

hobholes:~# /home/jejb/git/sgv4-tools/smp_test /sys/class/bsg/expander-2\:0
  SAS-1.1 format: 0
  vendor identification: LSILOGIC
  product identification: SASx12 A.0      
  product revision level: 

So we can class this one as a success ... 

Thanks!

James


