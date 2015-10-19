From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 10/12] megaraid_sas : SMAP restriction-do not access user
 memory from IOCTL code
Date: Mon, 19 Oct 2015 17:32:08 +0200
Message-ID: <56250CF8.2010003@redhat.com>
References: <201510150818.t9F8IDfb029670@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57457 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753463AbbJSPcL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Oct 2015 11:32:11 -0400
In-Reply-To: <201510150818.t9F8IDfb029670@palmhbs0.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: sumit.saxena@avagotech.com, linux-scsi@vger.kernel.org, stable@vger.kernel.org, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com, kiran-kumar.kasturi@avagotech.com
Cc: uday.lingala@avagotech.com

On 15.10.2015 10:10, sumit.saxena@avagotech.com wrote:
> This is an issue on SMAP enabled CPUs and 32 bit apps running on 64 bit OS. Donot access user memory from kernel code.
> SMAP bit restricts to access user memory from kernel code. Corresponding Redhat Bugzilla id for this is:[Bug 1267911].
>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
> Signed-off-by: Kashyap Desai <kashyap.desai@avagotech.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas

