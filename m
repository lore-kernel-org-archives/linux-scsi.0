From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH RESEND 13/18] megaraid_sas : add endianess conversions
 for all ones
Date: Tue, 21 Apr 2015 14:13:53 +0200
Message-ID: <55363F01.4080702@redhat.com>
References: <201504201236.t3KCagKv016670@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45853 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754943AbbDUMNz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Apr 2015 08:13:55 -0400
In-Reply-To: <201504201236.t3KCagKv016670@palmhbs0.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumit.Saxena@avagotech.com, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com

On 04/20/2015 02:34 PM, Sumit.Saxena@avagotech.com wrote:
> Add noop conversions for all ones to make sparse happy.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas

