From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH v5] cmdfilter: clean up sysfs interface
Date: Mon, 3 Nov 2008 13:01:17 +0900
Message-ID: <20081103130126I.fujita.tomonori@lab.ntt.co.jp>
References: <20080809135520.GJ8618@parisc-linux.org>
	<20080810163206X.fujita.tomonori@lab.ntt.co.jp>
	<6cf6b73e0811011056w7f829f4fq485f6299122ed643@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:39192 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754457AbYKCECY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 2 Nov 2008 23:02:24 -0500
In-Reply-To: <6cf6b73e0811011056w7f829f4fq485f6299122ed643@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: adel.gadllah@gmail.com
Cc: fujita.tomonori@lab.ntt.co.jp, matthew@wil.cx, linux-scsi@vger.kernel.org, jens.axboe@oracle.com, viro@zeniv.linux.org.uk, pjones@redhat.com, dougg@torque.net, dan.j.williams@intel.com, James.Bottomley@hansenpartnership.com

On Sat, 1 Nov 2008 18:56:20 +0100
"Adel Gadllah" <adel.gadllah@gmail.com> wrote:

> The sysfs bits got disabled in 2.6.27 in commit
> 2dc75d3c3b49c64fd26b4832a7efb75546cb3fc5 .
> What are the remaining bugs that needs to get fixed to reenable it for
> 2.6.28 (or if its too late .29) ?

cmdfilter has some design problems related with the way to use kobject
(discussed several times on lkml during 2.6.27-rcX cycles). As far as
I know, nobody tries to fix them.
