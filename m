From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH 3/4] aic94xx: cleanup after a discovery error
Date: Sun, 12 Nov 2006 10:31:36 -0800
Message-ID: <45576888.1090900@us.ibm.com>
References: <1163102636.6521.19.camel@localhost.localdomain> <45551D3B.7070007@us.ibm.com>
Reply-To: "Darrick J. Wong" <djwong@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:43917 "EHLO e3.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1752375AbWKLSbk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 12 Nov 2006 13:31:40 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e3.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id kACIVcWc013276
	for <linux-scsi@vger.kernel.org>; Sun, 12 Nov 2006 13:31:38 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id kACIVcCp283408
	for <linux-scsi@vger.kernel.org>; Sun, 12 Nov 2006 13:31:38 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id kACIVcXP017137
	for <linux-scsi@vger.kernel.org>; Sun, 12 Nov 2006 13:31:38 -0500
In-Reply-To: <45551D3B.7070007@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Alexis Bruemmer <alexisb@us.ibm.com>

Darrick J. Wong wrote:

> It'll still oops; sas_ex_discover_end_dev needs to be updated to know
> that it needn't call sas_rphy_free if the device-specific discovery
> functions fail.  This patch should fix that case too.

Erm... this patch is only necessary if one has jejb's "better error
handling in sas_ex_discover_end_dev()" patch applied.

http://www.kernel.org/git/?p=linux/kernel/git/jejb/aic94xx-sas-2.6.git;a=commitdiff;h=82f6bc0849b6fce9a965dde11dd6f685adc7285e

(My queue of pending patches is getting a bit too long, methinks.)

--D
