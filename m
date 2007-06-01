From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [Stgt-devel] Question for pass-through target design
Date: Fri, 01 Jun 2007 19:12:01 +0400
Message-ID: <46603741.308@vlnb.net>
References: <20070504160712.GB16528@austin.ibm.com>	<200705041704.l44H4WXa003789@mbox.iij4u.or.jp>	<463B72F6.3000207@torque.net> <20070506053629P.fujita.tomonori@lab.ntt.co.jp> <463F36AC.3010207@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-relay-02.mailcluster.net ([85.249.135.243]:34477 "EHLO
	mail-relay-02.mailcluster.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759125AbXFAPL6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Jun 2007 11:11:58 -0400
In-Reply-To: <463F36AC.3010207@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: stgt-devel@lists.berlios.de
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, dougg@torque.net, scst-devel <scst-devel@lists.sourceforge.net>, linux-scsi@vger.kernel.org

Vladislav Bolkhovitin wrote:
> So, if you need in-kernel pass-through I would suggest you to look at
> SCST project (http://scst.sf.net), which is currently stable and mature,
> although also not fully finished yet. It was historically from the very
> beginning designed for full feature in-kernel pass-through for not only
> stateless SCSI devices, like disks, but also for stateful SCSI devices
> (like SSC ones a.k.a. tapes), where the correct handling of all above is
> essential. In additional to considerably better performance, the
> complete in-kernel approach makes the code simpler, smaller and cleaner
> as well as allows such things as zero-copy buffered file IO, i.e. when 
> data are sent to remote initiators or received from them directly 
> from/to the page cache (currently under development). For those who need 
> implementing SCSI devices in the user space scst_user module is about to 
> be added. Since the SCSI state machine is in kernel the interface 
> provided by scst_user is very simple, it essentially consists from only 
> a single IOCTL and allows to have overhead as low as a single syscall 
> per SCSI command without any additional context switches. It is already 
> implemented and works. For some legal reasons I can't at the moment 
> publish it, but you can see its full description in the project's SVN 
> docs (you can get them using command "svn co 
> https://svn.sourceforge.net/svnroot/scst/trunk/doc").

Now I released scst_user module and it is available from the SCST SVN, 
so you can check how simply it allows to write SCSI devices, like a VTL, 
in the user space.

Vlad
