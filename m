From: Rob Evers <revers@redhat.com>
Subject: Re: [PATCH V4 0/5] scsi: Configure number of LUs reported by 'report-luns'
Date: Thu, 20 Nov 2014 13:41:41 -0500
Message-ID: <546E35E5.3020604@redhat.com>
References: <1416237730-1862-1-git-send-email-revers@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36839 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756658AbaKTSlm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Nov 2014 13:41:42 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id sAKIfgL4031848
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-scsi@vger.kernel.org>; Thu, 20 Nov 2014 13:41:42 -0500
In-Reply-To: <1416237730-1862-1-git-send-email-revers@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <chellwig@redhat.com>
Cc: linux-scsi@vger.kernel.org

On 11/17/2014 10:22 AM, Rob Evers wrote:
> This patch set retrieves the number of LUs available on a target
> using the report-luns command.  The initial size of the report-luns
> command is 512 entries, as the previous default initial number was.
> If more LUs than 511 are present on a target, the report-luns is
> re-issued with the size indicated in the result of the original
> report-luns, up to max_report_luns.

Thanks for your feedback. I'll work on V5.

Rob
