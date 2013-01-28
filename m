From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH RFC 0/9] [SCSI] Enhanced sense and Unit Attention handling
Date: Mon, 28 Jan 2013 16:44:08 +0100
Message-ID: <51069CC8.3000103@acm.org>
References: <1358526434-1173-1-git-send-email-emilne@redhat.com> <CAO+b5-oKyPoSdKJPcyaf4FkDUNH25Cwwz=_C4WiwvpfauNqStQ@mail.gmail.com> <51011D2E.305@suse.de> <CAO+b5-ptjPEbCrKEpdCEZBCh5Xs7ycXQA5V+iohAL4TSfbUzFg@mail.gmail.com> <5106939E.1010301@tributary.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jacques.telenet-ops.be ([195.130.132.50]:58767 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154Ab3A1PoP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Jan 2013 10:44:15 -0500
In-Reply-To: <5106939E.1010301@tributary.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Linton <jlinton@tributary.com>
Cc: Hannes Reinecke <hare@suse.de>, "Ewan D. Milne" <emilne@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 01/28/13 16:05, Jeremy Linton wrote:
> What I think your looking for is RSCN (Registered State Change notification).
> Hook that, and then check the name server. This will tell you when ports get
> added/removed. You can then report luns against lun 0 of all the known target
> ports. This allows you to transparently detect changes.
>
> Otherwise, you run the risk of trapping UA's in the lower level portions of
> the stack that _REALLY_ need to be propagated to the controlling driver or
> application.

Thanks for the feedback. Unfortunately sending an RSCN is only possible 
when using Fibre Channel as transport layer. I'm looking for a solution 
that also works with other SCSI transports, e.g. iSCSI and SRP.

Bart.

