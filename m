From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: timeout during sas discovery (aic94xx)
Date: Mon, 28 Aug 2006 22:44:08 -0700
Message-ID: <44F3D428.60705@us.ibm.com>
References: <20060828231832.GA1037@us.ibm.com>
Reply-To: "Darrick J. Wong" <djwong@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:55493 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1751196AbWH2FoL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Aug 2006 01:44:11 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e5.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id k7T5iBKB027923
	for <linux-scsi@vger.kernel.org>; Tue, 29 Aug 2006 01:44:11 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id k7T5iBHr288808
	for <linux-scsi@vger.kernel.org>; Tue, 29 Aug 2006 01:44:11 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k7T5iALD024867
	for <linux-scsi@vger.kernel.org>; Tue, 29 Aug 2006 01:44:11 -0400
In-Reply-To: <20060828231832.GA1037@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, andmike@us.ibm.com, alexisb@us.ibm.com

malahal@us.ibm.com wrote:
> Here are the messages when a task timeout occurs while doing DISCOVERY.
> I am running "modprobe aic94xx" and "modprobe -r aic94xx" in a loop on a
> maia system with VITESSE expanders. The problems happens after a few
> iterations (7-20 iterations). Were were hoping that James phy_reset
> patch would fix this but the patch didn't seem to help.

Uh... I don't think that phy_reset function ever gets called.  My
ten-second grep of the libsas/aic94xx code doesn't yield and takers.
Maybe one of those functions that gets called after time index 575.791
should be doing that?

--D
