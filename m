From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v2 2/3] Configure reported luns
Date: Tue, 19 Feb 2013 08:17:07 +0100
Message-ID: <512326F3.3020408@acm.org>
References: <1361214952-28978-1-git-send-email-revers@redhat.com> <1361214952-28978-3-git-send-email-revers@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jacques.telenet-ops.be ([195.130.132.50]:47690 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686Ab3BSHRJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Feb 2013 02:17:09 -0500
In-Reply-To: <1361214952-28978-3-git-send-email-revers@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rob Evers <revers@redhat.com>
Cc: linux-scsi@vger.kernel.org

On 02/18/13 20:15, Rob Evers wrote:
>   	length = ((data[0] << 24) | (data[1] << 16) |
>   		  (data[2] << 8) | (data[3] << 0));
[ ... ]
> +				length = ((data[0] << 24) | (data[1] << 16) |
> +				  (data[2] << 8) | (data[3] << 0));

Please consider using get_unaligned_be32() for these two statements.

Thanks,

Bart.

