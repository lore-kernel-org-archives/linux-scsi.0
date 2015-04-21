From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH RESEND 10/18] megaraid_sas : megasas_complete_outstanding_ioctls()
 can be static
Date: Tue, 21 Apr 2015 14:34:03 +0200
Message-ID: <553643BB.2090803@redhat.com>
References: <201504201238.t3KCc8GM016945@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50563 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754971AbbDUMeG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Apr 2015 08:34:06 -0400
In-Reply-To: <201504201238.t3KCc8GM016945@palmhbs0.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumit.Saxena@avagotech.com, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com

On 04/20/2015 02:35 PM, Sumit.Saxena@avagotech.com wrote:
> drivers/scsi/megaraid/megaraid_sas_base.c:1701:6: sparse: symbol 'megasas_complete_outstanding_ioctls' was not declared. Should it be static?
>
> Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas

