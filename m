From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Fw: PROBLEM: Linux V. 2.6.3 panics with "Buffers at physical
	address >16Mb used for aha1542" at boot time
Date: 20 Feb 2004 10:06:02 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1077300363.2156.5.camel@mulgrave>
References: <20040218171212.0eb6618a.akpm@osdl.org>
	<1077243517.2164.61.camel@mulgrave> <1077265837.1297.9.camel@felicia>
	<1077295765.1937.0.camel@mulgrave>  <20040220175202.GA898@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:58265 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261359AbUBTSGy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Feb 2004 13:06:54 -0500
In-Reply-To: <20040220175202.GA898@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: "Dr. Ernst Molitor" <molitor@uni-bonn.de>, Andrew Morton <akpm@osdl.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, 2004-02-20 at 09:52, Mike Anderson wrote:
> What about the buffer off the stack that cdrom_is_mrw uses? cgc->buffer
> is set to this stack buffer which is used directly in sr_do_ioctl when
> scsi_wait_req is called.

Well, OK, I stopped after I found one problem ...

James


