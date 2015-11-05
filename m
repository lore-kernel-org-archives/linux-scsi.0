From: Timur Tabi <timur@codeaurora.org>
Subject: Re: [PATCH 3/4] scsi: fix compiler warning for sg
Date: Thu, 5 Nov 2015 09:25:11 -0600
Message-ID: <563B74D7.5090505@codeaurora.org>
References: <1446698789-19308-1-git-send-email-okaya@codeaurora.org>
 <1446698789-19308-3-git-send-email-okaya@codeaurora.org>
 <CAHp75VfB1ToEZXRbxeWkU7xsWJkMz3v3A1O5QsH9LiiV4Be-iw@mail.gmail.com>
 <563B7180.2000405@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47797 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756303AbbKEPZN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Nov 2015 10:25:13 -0500
In-Reply-To: <563B7180.2000405@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sinan Kaya <okaya@codeaurora.org>, Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, cov@codeaurora.org, jcm@redhat.com, Doug Gilbert <dgilbert@interlog.com>, "James E.J. Bottomley" <JBottomley@odin.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

Sinan Kaya wrote:
 >
 >
 > #define MULDIV(X,MUL,DIV)    mult_frac64(X, MUL, DIV)

Why bother with the macro at all? Just change the code to use do_div() 
directly. It's possible that the original code was written before 
do_div() became standard, or the developer didn't know about, which is 
why we have this macro in the first place.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the
Code Aurora Forum, hosted by The Linux Foundation.
