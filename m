From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: mpt2sas losing reset events with cable pulls?
Date: Tue, 30 Aug 2011 22:41:14 -0400
Message-ID: <4E5D9F4A.80009@interlog.com>
References: <1314751868-1112-1-git-send-email-roland@kernel.org>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:34298 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754895Ab1HaClW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Aug 2011 22:41:22 -0400
In-Reply-To: <1314751868-1112-1-git-send-email-roland@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roland Dreier <roland@kernel.org>
Cc: Kashyap Desai <kashyap.desai@lsi.com>, Eric Moore <eric.moore@lsi.com>, eric@purestorage.com, linux-scsi@vger.kernel.org

On 11-08-30 08:51 PM, Roland Dreier wrote:
> Hi!
>
> We have a system with mpt2sas driver from the upstream kernel --
>
>      #define MPT2SAS_DRIVER_VERSION              "09.100.00.00"
>
> and hardware:
>
>      mpt2sas1: LSISAS2008: FWVersion(09.00.00.00), ChipRevision(0x03), BiosVersion(07.17.00.00)

Most LSI HBA's based on the LSISAS2008 chip are now at
firmware version 10.00 . Perhaps you could retest with
that firmware.

Doug Gilbert
