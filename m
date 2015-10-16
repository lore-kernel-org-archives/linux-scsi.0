From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 05/12] megaraid_sas : Donot use PAGE_SIZE macro for
 calculation of max_sectors per IO request
Date: Fri, 16 Oct 2015 16:44:37 +0200
Message-ID: <56210D55.1000703@redhat.com>
References: <201510150817.t9F8HMD6029627@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47761 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751843AbbJPOoj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Oct 2015 10:44:39 -0400
In-Reply-To: <201510150817.t9F8HMD6029627@palmhbs0.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: sumit.saxena@avagotech.com, linux-scsi@vger.kernel.org, stable@vger.kernel.org, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com, kiran-kumar.kasturi@avagotech.com
Cc: uday.lingala@avagotech.com

On 15.10.2015 10:10, sumit.saxena@avagotech.com wrote:
> Do not use PAGE_SIZE marco to calculate max_sectors per IO request. Driver code assumes PAGE_SIZE will be always 4096 which can do lead to wrongly calculated value if PAGE_SIZE is not 4096. This issue was reported in Ubuntu Bugzilla Bug #1475166.
>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
> Signed-off-by: Kashyap Desai <kashyap.desai@avagotech.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas

