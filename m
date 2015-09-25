From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH v3 19/32] cxlflash: Correct usage of scsi_host_put()
Date: Fri, 25 Sep 2015 15:35:14 -0500
Message-ID: <5605B002.8000106@linux.vnet.ibm.com>
References: <1443123193-16498-1-git-send-email-mrochs@linux.vnet.ibm.com>
 <1443123619-17347-1-git-send-email-mrochs@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:46845 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933204AbbIYUfY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Sep 2015 16:35:24 -0400
Received: from localhost
	by e34.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Fri, 25 Sep 2015 14:35:24 -0600
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
	by d03dlp02.boulder.ibm.com (Postfix) with ESMTP id BC8013E40041
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2015 14:35:20 -0600 (MDT)
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t8PKWFeV45416612
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2015 13:32:15 -0700
Received: from d03av03.boulder.ibm.com (localhost [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t8PKZIvn020969
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2015 14:35:20 -0600
In-Reply-To: <1443123619-17347-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Ian Munsie <imunsie@au1.ibm.com>, Daniel Axtens <dja@ozlabs.au.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Tomas Henzl <thenzl@redhat.com>, David Laight <David.Laight@ACULAB.COM>
Cc: Michael Neuling <mikey@neuling.org>, linuxppc-dev@lists.ozlabs.org, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

Reviewed-by: Brian King <brking@linux.vnet.ibm.com>

-- 
Brian King
Power Linux I/O
IBM Linux Technology Center

