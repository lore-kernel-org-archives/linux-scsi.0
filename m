From: Luben Tuikov <luben@splentec.com>
Subject: Q: assumptions on make_request() and request_fn()
Date: Wed, 18 Sep 2002 16:53:16 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3D88E7BC.63735D7E@splentec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from splentec.com (canoe.splentec.com [209.47.35.250])
	by pepsi.splentec.com (8.11.6/8.11.0) with ESMTP id g8IKrDH10990
	for <linux-scsi@vger.kernel.org>; Wed, 18 Sep 2002 16:53:13 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

What are the assumtions for calling make_request() or
the request_fn()?

Interrupt context or process context or both?

(2.4/2.5)

Thanks,
-- 
Luben
