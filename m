From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: Re: [PATCH 7/7] cxlflash: Increase cmd_per_lun for better throughput
Date: Tue, 8 Mar 2016 11:56:42 -0600
Message-ID: <56DF125A.8000202@linux.vnet.ibm.com>
References: <1457128424-53017-1-git-send-email-ukrishn@linux.vnet.ibm.com>
 <1457128520-53056-1-git-send-email-ukrishn@linux.vnet.ibm.com>
 <1457128520-53056-7-git-send-email-ukrishn@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e38.co.us.ibm.com ([32.97.110.159]:56400 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170AbcCHR4q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Mar 2016 12:56:46 -0500
Received: from localhost
	by e38.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <ukrishn@linux.vnet.ibm.com>;
	Tue, 8 Mar 2016 10:56:45 -0700
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id 255E919D8051
	for <linux-scsi@vger.kernel.org>; Tue,  8 Mar 2016 10:44:38 -0700 (MST)
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u28Hug5538731966
	for <linux-scsi@vger.kernel.org>; Tue, 8 Mar 2016 10:56:42 -0700
Received: from d03av01.boulder.ibm.com (localhost [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u28HufHk027851
	for <linux-scsi@vger.kernel.org>; Tue, 8 Mar 2016 10:56:42 -0700
In-Reply-To: <1457128520-53056-7-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, Brian King <brking@linux.vnet.ibm.com>, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

On 3/4/2016 3:55 PM, Uma Krishnan wrote:
> From: "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
>
> With the current value of cmd_per_lun at 16, the throughput
> over a single adapter is limited to around 150kIOPS.
>
> Increase the value of cmd_per_lun to 256 to improve
> throughput. With this change a single adapter is able to
> attain close to the maximum throughput (380kIOPS).
> Also change the number of RRQ entries that can be queued.
>
> Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>

Reviewed-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>

