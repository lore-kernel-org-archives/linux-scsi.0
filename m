From: Mark Lord <lkml@rtr.ca>
Subject: Re: BUG: SCSI SYNCHRONIZE_CACHE on driver unload
Date: Thu, 05 Aug 2004 19:13:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4112BF0A.3000807@rtr.ca>
References: <4112BC7A.1040102@rtr.ca> <20040805154826.633ff4cd.rddunlap@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cpu1185.adsl.bellglobal.com ([207.236.110.166]:44701 "EHLO
	mail.rtr.ca") by vger.kernel.org with ESMTP id S267790AbUHEXO0
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Aug 2004 19:14:26 -0400
In-Reply-To: <20040805154826.633ff4cd.rddunlap@osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: "Randy.Dunlap" <rddunlap@osdl.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Yup.  That's the exact bug.
-- 
Mark Lord
(hdparm keeper & the original "Linux IDE Guy")
