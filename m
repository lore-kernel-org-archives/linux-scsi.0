From: Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [SCSI] Avoid ld errors messages by marking sd_major noinline.
Date: Sat, 4 Mar 2006 17:15:00 +0000
Message-ID: <20060304171500.GA23236@linux-mips.org>
References: <20060304171227.GA16799@linux-mips.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ftp.linux-mips.org ([194.74.144.162]:57494 "EHLO
	ftp.linux-mips.org") by vger.kernel.org with ESMTP id S932204AbWCDRPE
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 4 Mar 2006 12:15:04 -0500
Received: from localhost.localdomain ([127.0.0.1]:15751 "EHLO bacchus.dhis.org")
	by ftp.linux-mips.org with ESMTP id S8133467AbWCDRGu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 4 Mar 2006 17:06:50 +0000
Received: from denk.linux-mips.net (denk.linux-mips.net [127.0.0.1])
	by bacchus.dhis.org (8.13.4/8.13.4) with ESMTP id k24HF0Oe023250
	for <linux-scsi@vger.kernel.org>; Sat, 4 Mar 2006 17:15:00 GMT
Received: (from ralf@localhost)
	by denk.linux-mips.net (8.13.4/8.13.4/Submit) id k24HF0j7023249
	for linux-scsi@vger.kernel.org; Sat, 4 Mar 2006 17:15:00 GMT
Content-Disposition: inline
In-Reply-To: <20060304171227.GA16799@linux-mips.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Duh...  Wrong patch attached.

  Ralf
