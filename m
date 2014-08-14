From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH scsi 1/1] libiscsi : Add T10 Data Integrity Feature support
Date: Thu, 14 Aug 2014 12:25:00 +0300
Message-ID: <53EC806C.20207@dev.mellanox.co.il>
References: <1407364668-20931-1-git-send-email-anish@chelsio.com> <1407364668-20931-2-git-send-email-anish@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:33985 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752323AbaHNJZI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Aug 2014 05:25:08 -0400
Received: by mail-wg0-f48.google.com with SMTP id x13so809281wgg.19
        for <linux-scsi@vger.kernel.org>; Thu, 14 Aug 2014 02:25:06 -0700 (PDT)
In-Reply-To: <1407364668-20931-2-git-send-email-anish@chelsio.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anish Bhatt <anish@chelsio.com>
Cc: linux-scsi@vger.kernel.org, hch@infradead.org, jbottomley@parallels.com, michaelc@cs.wisc.edu, kxie@chelsio.com, manojmalviya@chelsio.com

On 8/7/2014 1:37 AM, Anish Bhatt wrote:
> Signed-off-by: Anish Bhatt <anish@chelsio.com>
> Signed-off by: Manoj Malvia <manojmalviya@chelsio.com>
> Signed-off by: Karen Xie <kxie@chelsio.com>
> ---
>   drivers/scsi/libiscsi.c     |  61 +++++++--
>   drivers/scsi/libiscsi_tcp.c | 296 ++++++++++++++++++++++++++++++++++++++++----
>   include/scsi/libiscsi.h     |   6 +
>   include/scsi/libiscsi_tcp.h |  22 ++++
>   4 files changed, 349 insertions(+), 36 deletions(-)
>

Hey Anish,

Against what target did you guys test this stuff?

Sagi.
