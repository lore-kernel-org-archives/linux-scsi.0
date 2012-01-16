From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH] ipr: fix eeh recovery for 64-bit adapters
Date: Mon, 16 Jan 2012 16:04:09 -0600
Message-ID: <4F149ED9.2000304@linux.vnet.ibm.com>
References: <1326749425-28778-1-git-send-email-klebers@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:34669 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932069Ab2APWFc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Jan 2012 17:05:32 -0500
Received: from /spool/local
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Mon, 16 Jan 2012 15:05:31 -0700
Received: from d03relay05.boulder.ibm.com (d03relay05.boulder.ibm.com [9.17.195.107])
	by d03dlp02.boulder.ibm.com (Postfix) with ESMTP id 9222F3E4005E
	for <linux-scsi@vger.kernel.org>; Mon, 16 Jan 2012 15:04:17 -0700 (MST)
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay05.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q0GM4BaU109688
	for <linux-scsi@vger.kernel.org>; Mon, 16 Jan 2012 15:04:14 -0700
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q0GM4App007869
	for <linux-scsi@vger.kernel.org>; Mon, 16 Jan 2012 15:04:11 -0700
In-Reply-To: <1326749425-28778-1-git-send-email-klebers@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Wayne Boyer <wayneb@linux.vnet.ibm.com>, Wendy Xiong <wenxiong@linux.vnet.ibm.com>

Acked-by: Brian King <brking@linux.vnet.ibm.com>

-- 
Brian King
Linux on Power Virtualization
IBM Linux Technology Center


