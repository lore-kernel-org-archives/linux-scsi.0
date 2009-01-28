From: Mark Hounschell <dmarkh@cfl.rr.com>
Subject: SGIO interface question
Date: Wed, 28 Jan 2009 04:09:56 -0500
Message-ID: <498020E4.1060700@cfl.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.123]:41766 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbZA1KQa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Jan 2009 05:16:30 -0500
Received: from [10.10.10.100] (really [68.202.146.147])
          by cdptpa-omta04.mail.rr.com with ESMTP
          id <20090128090957.MEJR23506.cdptpa-omta04.mail.rr.com@[10.10.10.100]>
          for <linux-scsi@vger.kernel.org>; Wed, 28 Jan 2009 09:09:57 +0000
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

I open an sg device that is a scsi tape. How do I prevent a rewind of the tape
at close time?

Thanks in advance
Mark
