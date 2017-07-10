From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH v2 04/15] megaraid_sas: Call
 megasas_complete_cmd_dpc_fusion every 1 second while there are pending
 commands
Date: Mon, 10 Jul 2017 15:51:39 +0200
Message-ID: <9a937ec2-d69e-5fb4-0ff1-7f344f6b04b1@redhat.com>
References: <1499256029-16319-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1499256029-16319-5-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44145 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932079AbdGJNvm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 10 Jul 2017 09:51:42 -0400
In-Reply-To: <1499256029-16319-5-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Content-Language: en-MW
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com, hch@lst.de

On 5.7.2017 14:00, Shivasharan S wrote:
> Fix - megasas_wait_for_outstanding_fusion checks for pending commands every
> 1second. But megasas_complete_cmd_dpc_fusion is only called every 5seconds.
> If the commands are already completed by firmware, there is an additional
> delay of 5seconds before driver will process completion for these commands.
>
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

tomash
