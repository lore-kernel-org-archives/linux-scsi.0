From: Tony Battersby <tonyb@cybernetics.com>
Subject: Re: [PATCH] sg: fix races during device removal
Date: Wed, 31 Dec 2008 15:16:47 -0500
Message-ID: <495BD32F.2030502@cybernetics.com>
References: <495A40D4.5030901@cybernetics.com> <20081231173632N.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host64.cybernetics.com ([98.174.209.230]:1136 "EHLO
	mail.cybernetics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756349AbYLaUQu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Dec 2008 15:16:50 -0500
In-Reply-To: <20081231173632N.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: dgilbert@interlog.com, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com

FUJITA Tomonori wrote:
> Please use kref, the standard reference counting mechanism. Then you
> don't need to use sg_index_lock for it.
>
>   
OK, I am working on version 2 of the patch.  However, I keep running
into more problems, so it might not be ready for a few days.

Tony

