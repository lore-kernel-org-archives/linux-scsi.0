From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [RESEND][PATCH 04/10][SCSI]mpt2sas: Clear PFA Status on SGPIO when PFA Drive is Removed or Replaced
Date: Sun, 13 Jul 2014 11:00:28 -0400
Message-ID: <yq11ttpz4kz.fsf@sermon.lab.mkp.net>
References: <20140625103242.GA12918@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:19172 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753735AbaGMPA7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Jul 2014 11:00:59 -0400
In-Reply-To: <20140625103242.GA12918@avagotech.com> (Sreekanth Reddy's message
	of "Wed, 25 Jun 2014 16:02:42 +0530")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Reddy, Sreekanth" <Sreekanth.Reddy@avagotech.com>
Cc: jejb@kernel.org, JBottomley@Parallels.com, linux-scsi@vger.kernel.org, Sathya.Prakash@avagotech.com, Nagalakshmi.Nandigama@avagotech.com, linux-kernel@vger.kernel.org, hch@infradead.org, martin.petersen@oracle.com

>>>>> "Sreekanth" == Reddy, Sreekanth <Sreekanth.Reddy@avagotech.com> writes:

Sreekanth> Added code to send a SEP message that turns off the
Sreekanth> Predictive Failure LED when a drive is removed (if Predictive
Sreekanth> Failure LED was turned on).

Sreekanth> Added a new flag 'pfa_led_on' per device that tracks the
Sreekanth> status of Predictive Failure LED. When the drive is removed,
Sreekanth> this flag is checked and sends the SEP message to turn off
Sreekanth> the respective Predictive Failure LED.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
