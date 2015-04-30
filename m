From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 09/12] IB/srp: Remove a superfluous check from srp_free_req_data()
Date: Thu, 30 Apr 2015 12:37:59 +0200
Message-ID: <55420607.1060808@sandisk.com>
References: <5541EE21.3050809@sandisk.com> <5541EF4F.6050200@sandisk.com>
 <55420188.2020409@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0074.outbound.protection.outlook.com ([207.46.100.74]:30784
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751598AbbD3KiG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Apr 2015 06:38:06 -0400
In-Reply-To: <55420188.2020409@dev.mellanox.co.il>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>, Doug Ledford <dledford@redhat.com>
Cc: James Bottomley <jbottomley@odin.com>, Sagi Grimberg <sagig@mellanox.com>, Sebastian Parschauer <sebastian.riemer@profitbricks.com>, linux-rdma <linux-rdma@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 04/30/15 12:18, Sagi Grimberg wrote:
> On 4/30/2015 12:01 PM, Bart Van Assche wrote:
>> All srp_free_req_data() callers guarantee that ch->target != NULL
>> hence remove the ch->target test from srp_free_req_data().
>
> ch->target is not referenced anywhere in this routine. So why does
> this guarantee matter?

I can shorten the description of this patch if you want.

Bart.
