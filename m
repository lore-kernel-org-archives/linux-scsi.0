From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: Kernel crash with AIC94xx (one step forward, hope it's lucky)
Date: Tue, 01 May 2007 08:57:13 -0700
Message-ID: <46376359.1080004@us.ibm.com>
References: <133536.33882.qm@web31804.mail.mud.yahoo.com> <4630770C.60209@gmail.com>
Reply-To: "Darrick J. Wong" <djwong@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:57070 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753215AbXEAP4o (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 May 2007 11:56:44 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l41FuhGg011963
	for <linux-scsi@vger.kernel.org>; Tue, 1 May 2007 11:56:43 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l41Fuh0d533724
	for <linux-scsi@vger.kernel.org>; Tue, 1 May 2007 11:56:43 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l41FugbZ008213
	for <linux-scsi@vger.kernel.org>; Tue, 1 May 2007 11:56:43 -0400
In-Reply-To: <4630770C.60209@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: brailateo@gmail.com
Cc: ltuikov@yahoo.com, James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi <linux-scsi@vger.kernel.org>

Constantin Teodorescu wrote:

> 03:02:15 kernel: ------------[ cut here ]------------
> 03:02:15 kernel: kernel BUG at drivers/scsi/aic94xx/aic94xx_hwi.h:354!

On the odd chance you still have this controller (and have the time to
test out patches), would you mind applying this patch:

http://sweaglesw.net/~djwong/docs/17-aic94xx-hwi-bugon_1.patch

and reporting back to me what happens?

--D
