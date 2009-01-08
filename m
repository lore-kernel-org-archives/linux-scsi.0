From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH 0/2] sg: fix races during device removal (v2)
Date: Thu, 08 Jan 2009 18:21:57 -0500
Message-ID: <49668A95.2090805@interlog.com>
References: <49625A67.3000304@cybernetics.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:40524 "EHLO
	elrond2.infotech.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506AbZAHXWE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Jan 2009 18:22:04 -0500
In-Reply-To: <49625A67.3000304@cybernetics.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tony Battersby <tonyb@cybernetics.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, James.Bottomley@HansenPartnership.com, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

Tony Battersby wrote:
> This is version 2 of my patch, this time using a kref instead of int.
> There are also a lot of other changes since the first version since I
> found even more bugs both through testing and source code analysis.
> I have split the patch up into two parts: the first patch fixes
> races between open, close, device removal, and command completion.
> The second patch fixes some races I spotted in ioctl(SG_IO).

Okay, lets go with v2.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
