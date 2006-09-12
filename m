From: Helge Hafting <helge.hafting@aitel.hist.no>
Subject: Re: [PATCH] BODGE scsi misc module reference count checks with no
 MODULE_UNLOAD
Date: Tue, 12 Sep 2006 11:19:43 +0200
Message-ID: <45067BAF.8070603@aitel.hist.no>
References: <45067632.4020906@shadowen.org> <20060912090223.GA31576@shadowen.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from embla.aitel.hist.no ([158.38.50.22]:12519 "HELO
	embla.aitel.hist.no") by vger.kernel.org with SMTP id S965155AbWILJXE
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Sep 2006 05:23:04 -0400
In-Reply-To: <20060912090223.GA31576@shadowen.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Whitcroft <apw@shadowen.org>
Cc: Andrew Morton <akpm@osdl.org>, James.Bottomley@SteelEye.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Andy Whitcroft wrote:
> BODGE scsi misc module reference count checks with no MODULE_UNLOAD
>
> A quick bodge to try and get this to compile for testing.
>
> Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Thanks, this was necessary to compile a non-modular kernel.

Helge Hafting
