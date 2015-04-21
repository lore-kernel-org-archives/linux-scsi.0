From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH RESEND 14/18] megaraid_sas : move endianess conversion
 into caller of megasas_get_seq_num
Date: Tue, 21 Apr 2015 14:19:55 +0200
Message-ID: <5536406B.5010709@redhat.com>
References: <201504201236.t3KCaqIg016688@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46774 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750775AbbDUMT6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Apr 2015 08:19:58 -0400
In-Reply-To: <201504201236.t3KCaqIg016688@palmhbs0.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumit.Saxena@avagotech.com, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com

On 04/20/2015 02:34 PM, Sumit.Saxena@avagotech.com wrote:
> Converting structure fields in place is always a bad idea, and in this case
> by moving it into the only caller we also only have to do a single byte
> swap as most fields of this structure are never used.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas

