From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/1] sd: do not let LBPME bit stop the VPDs speak
Date: Wed, 09 Mar 2016 21:24:29 -0500
Message-ID: <yq1mvq7qdcy.fsf@sermon.lab.mkp.net>
References: <56df97e0.d08d420a.58e8f.3162@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:30628 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262AbcCJCYg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Mar 2016 21:24:36 -0500
In-Reply-To: <56df97e0.d08d420a.58e8f.3162@mx.google.com> (tom's message of
	"Wed, 9 Mar 2016 11:26:16 +0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: tom.ty89@gmail.com
Cc: linux-scsi@vger.kernel.org

>>>>> "Tom" == tom ty89 <tom.ty89@gmail.com> writes:

Tom,

Tom> Some devices have details of their support on unmapping on the
Tom> Block Limits and/or Logical Block Provisioning VPDs while they do
Tom> not set the LBPME bit to 1. Though this is required by the SCSI
Tom> standards, the VPDs are giving even more concrete details about the
Tom> support, so they should be used even when the bit is set to 0.

I am not going to enable an already brittle feature if a device can't
report the right thing.

Does the bridge report LBPME=1 if you plug in an SSD?

-- 
Martin K. Petersen	Oracle Linux Engineering
