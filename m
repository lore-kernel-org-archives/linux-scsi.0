From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 4/6] fusion: don't use flush_scheduled_work()
Date: Tue, 11 Jan 2011 16:13:26 +0100
Message-ID: <20110111151326.GA15933@htj.dyndns.org>
References: <1292943721-4519-1-git-send-email-tj@kernel.org>
 <1292943721-4519-5-git-send-email-tj@kernel.org>
 <B2FD678A64EAAD45B089B123FDFC3ED70916AAA0@inbmail01.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:63240 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755457Ab1AKPNc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Jan 2011 10:13:32 -0500
Content-Disposition: inline
In-Reply-To: <B2FD678A64EAAD45B089B123FDFC3ED70916AAA0@inbmail01.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James.Bottomley@suse.de" <James.Bottomley@suse.de>, "fujita.tomonori@lab.ntt.co.jp" <fujita.tomonori@lab.ntt.co.jp>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Moore, Eric" <Eric.Moore@lsi.com>, "dgilbert@interlog.com" <dgilbert@interlog.com>

On Mon, Jan 10, 2011 at 01:00:58PM +0530, Desai, Kashyap wrote:
> Need to add header of function mptspi_suspend.  Logical part of the
> patch looks OK to me. Please consider this patch as an ACKed by me.

Will do so.  Thank you.

-- 
tejun
