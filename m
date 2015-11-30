From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 1/2] scsi_transport_fc: Introduce scsi_host_{get,put}()
Date: Mon, 30 Nov 2015 09:37:39 -0800
Message-ID: <565C8963.7050009@sandisk.com>
References: <564F910E.9070306@sandisk.com> <564F9190.5090103@sandisk.com>
 <yq1vb8jgzlv.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2on0065.outbound.protection.outlook.com ([65.55.169.65]:21246
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751484AbbK3Rhp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Nov 2015 12:37:45 -0500
In-Reply-To: <yq1vb8jgzlv.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, James Smart <james.smart@emulex.com>

On 11/30/2015 09:34 AM, Martin K. Petersen wrote:
>>>>>> "Bart" == Bart Van Assche <bart.vanassche@sandisk.com> writes:
>
> Bart,
>
> Bart> Use scsi_host_{get,put}() instead of open-coding these functions.
> Bart> Compile-tested only.
>
> Do you want me to queue this as a general cleanup for 4.5 (independently
> of the leak patch)?

Hello Martin,

That would be appreciated.

Thanks,

Bart.
