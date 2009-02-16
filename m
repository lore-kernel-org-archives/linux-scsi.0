From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [osd-dev] [PATCH version 2] libosd: Fix NULL dereference BUG
 when target is not OSD conformant
Date: Mon, 16 Feb 2009 15:18:24 +0200
Message-ID: <499967A0.80908@panasas.com>
References: <498EE637.3030800@panasas.com> <498F020E.808@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:5749 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754528AbZBPNSa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Feb 2009 08:18:30 -0500
In-Reply-To: <498F020E.808@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Fuerst Lars <lars.fuerst@thomson.net>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, open-osd mailing-list <osd-dev@open-osd.org>

Boaz Harrosh wrote:
> Very old OSC's Target had a BUG in the Get/Set attributes where
> it was looking in the wrong places for attribute lists length.
> If used with the open-osd initiator, the initiator would dereference
> a NULL pointer when retrieving system_information attributes.
> 
> Checks are added that retrieval of each attribute is successful
> before accessing its value.
> 
> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
Tested-by: Fuerst Lars <lars.fuerst@thomson.net>

James please submit this patch on top of current scsi-misc for a fix of a serious
BUG. It should be submitted together with the osd patches for 2.6.30.

Thanks in advance
Boaz
