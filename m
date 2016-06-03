From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH] scsi: Add QEMU CD-ROM to VPD Inquiry Blacklist
Date: Fri, 3 Jun 2016 14:14:01 -0700
Message-ID: <ecebbb72-1359-bce6-81bd-1fea9b37f4e2@sandisk.com>
References: <1464702149-26573-1-git-send-email-emilne@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0059.outbound.protection.outlook.com ([207.46.100.59]:43008
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752130AbcFCVOJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Jun 2016 17:14:09 -0400
In-Reply-To: <1464702149-26573-1-git-send-email-emilne@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Ewan D. Milne" <emilne@redhat.com>, linux-scsi@vger.kernel.org, Tom Yan <tom.ty89@gmail.com>

On 05/31/2016 06:42 AM, Ewan D. Milne wrote:
> Linux fails to boot as a guest with a QEMU CD-ROM:
> ...
> Fix this by suppressing VPD inquiry for this device.

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
