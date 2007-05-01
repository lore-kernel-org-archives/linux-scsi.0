From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH] aacraid: superfluous adapter reset for IBM 8 series ServeRAID
 controllers
Date: Tue, 01 May 2007 09:37:56 -0700
Message-ID: <46376CE4.7080403@us.ibm.com>
References: <AE4F746F2AECFC4DA4AADD66A1DFEF018FDDBD@otce2k301.adaptec.com>
Reply-To: "Darrick J. Wong" <djwong@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:58322 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754736AbXEAQhY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 May 2007 12:37:24 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e3.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l41Fa26E024095
	for <linux-scsi@vger.kernel.org>; Tue, 1 May 2007 11:36:02 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l41GbNqp531692
	for <linux-scsi@vger.kernel.org>; Tue, 1 May 2007 12:37:23 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l41GbMVc029613
	for <linux-scsi@vger.kernel.org>; Tue, 1 May 2007 12:37:23 -0400
In-Reply-To: <AE4F746F2AECFC4DA4AADD66A1DFEF018FDDBD@otce2k301.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: linux-scsi@vger.kernel.org, Alexis Bruemmer <ahbruemm@us.ibm.com>, James Bottomley <James.Bottomley@SteelEye.com>

Salyzyn, Mark wrote:
> The kexec patch introduced a superfluous (and otherwise inert) reset of
> some adapters. The register can have a hardware default value that has
> zeros for the undefined interrupts. This patch refines the test of the
> interrupt enable register to focus on only the interrupts that affect
> the driver in order to detect if an incomplete shutdown of the Adapter
> had occurred (kdump).

Tests out ok on the affected machines, so:

Acked-by: Darrick J. Wong <djwong@us.ibm.com>

--D
