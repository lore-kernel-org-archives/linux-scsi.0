From: Masao Fukuchi <fukuchi.masao@jp.fujitsu.com>
Subject: Re: [PATCH 2.6 ] MPT Fusion driver 3.01.06 update
Date: Fri, 07 May 2004 09:47:31 +0900
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200405070047.AA03227@fukuchi.jp.fujitsu.com>
References: <0E3FA95632D6D047BA649F95DAB60E57045F11CE@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:17328 "EHLO
	fgwmail5.fujitsu.co.jp") by vger.kernel.org with ESMTP
	id S261920AbUEGArh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 May 2004 20:47:37 -0400
Received: from m2.gw.fujitsu.co.jp ([10.0.50.72]) by fgwmail5.fujitsu.co.jp (8.12.10/Fujitsu Gateway)
	id i470lYvH030730 for <linux-scsi@vger.kernel.org>; Fri, 7 May 2004 09:47:34 +0900
	(envelope-from fukuchi.masao@jp.fujitsu.com)
Received: from s0.gw.fujitsu.co.jp by m2.gw.fujitsu.co.jp (8.12.10/Fujitsu Domain Master)
	id i470lX7u019133 for <linux-scsi@vger.kernel.org>; Fri, 7 May 2004 09:47:33 +0900
	(envelope-from fukuchi.masao@jp.fujitsu.com)
Received: from fjmail504.fjmail.jp.fujitsu.com (fjmail504-0.fjmail.jp.fujitsu.com [10.59.80.102]) by s0.gw.fujitsu.co.jp (8.12.10)
	id i470lXgu009692 for <linux-scsi@vger.kernel.org>; Fri, 7 May 2004 09:47:33 +0900
	(envelope-from fukuchi.masao@jp.fujitsu.com)
Received: from fukuchi.jp.fujitsu.com
 (fjscan502-0.fjmail.jp.fujitsu.com [10.59.80.122])
 by fjmail504.fjmail.jp.fujitsu.com
 (Sun Internet Mail Server sims.4.0.2001.07.26.11.50.p9)
 with SMTP id <0HXB00J6WJJ8T2@fjmail504.fjmail.jp.fujitsu.com> for
 linux-scsi@vger.kernel.org; Fri,  7 May 2004 09:47:32 +0900 (JST)
In-reply-to: <0E3FA95632D6D047BA649F95DAB60E57045F11CE@exa-atlanta>
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Emoore@lsil.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@steeleye.com

Hi Eric,

I confirmed your patch fixes following problem.
>Date: Wed, 14 Apr 2004 10:07:46 +0900
>From: Masao Fukuchi <fukuchi.masao@jp.fujitsu.com>
>Subject: [RFC][PATCH]SCSI signal(I/O) failure causes no response

Thanks,
Fukuchi

Moore, Eric Dean wrote:
>This is an update for the MPT Fusion drivers 2.6 kernel.
>
>This is mpt version is 3.01.06  The attached patch is made
>against 3.01.05 driver.
>
>Changelog: MPI_IOCSTATUS_SCSI_PROTOCOL_ERROR; return DID_SOFT_ERROR.
>
>
>You can download full source as well as the patches for this 
>driver at:
>ftp://ftp.lsil.com/HostAdapterDrivers/linux/FiberChannel/2.6-patches/3.01.06
>/
>
>
>Eric Moore
>Staff Engineer
>Standard Storage Products Division
>LSI Logic Corporation
>4420 Arrowswest Drive
>Colorado Springs, CO 80907
>Tel: (719) 533-7056
>Email: emoore@lsil.com
>Web: http://www.lsilogic.com/
>
