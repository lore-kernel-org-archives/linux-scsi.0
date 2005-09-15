From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH RFC/RFT 3/4] convert sg
Date: Thu, 15 Sep 2005 22:10:02 +1000
Message-ID: <4329649A.6000406@torque.net>
References: <1126736390.16778.26.camel@max>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:7868 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S1751152AbVIOMJn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Sep 2005 08:09:43 -0400
In-Reply-To: <1126736390.16778.26.camel@max>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi@vger.kernel.org

Mike Christie wrote:
> Convert sg to always to scatterlist IO.
> 
> This is not the complete cleanup I wanted to do, but nothing should
> be broken like in my past patches. st and osst can be converted to
> use the same interface. Eventually, I would like to convert them
> to use the blk_rq_map_user* functions but becuase of the
> large requests and them reserving the buffers themselves, and
> sg's mmap code I coverted them to use the map_kern_iov function
> first.

Thanks for keeping the sg driver's feature set. I'll
start testing, ironically mostly on SATA disks :-)

Doug Gilbert
