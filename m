From: Andi Kleen <ak@muc.de>
Subject: Re: 2.6.6 + Adaptec I2O
Date: Tue, 01 Jun 2004 19:08:51 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <m3llj7i4t8.fsf@averell.firstfloor.org>
References: <547AF3BD0F3F0B4CBDC379BAC7E4189FAD510E@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zero.aec.at ([193.170.194.10]:3591 "EHLO zero.aec.at")
	by vger.kernel.org with ESMTP id S265126AbUFARIz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Jun 2004 13:08:55 -0400
In-Reply-To: <547AF3BD0F3F0B4CBDC379BAC7E4189FAD510E@otce2k03.adaptec.com> (Mark
 Salyzyn's message of "Tue, 1 Jun 2004 11:11:22 -0400")
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: linux-scsi@vger.kernel.org

"Salyzyn, Mark" <mark_salyzyn@adaptec.com> writes:

> +	- Added __x86_64__ ifdef for signature, reporting PROC_SEXIUM for
> +	  processor type.

PROC_QUINDECIUM would be more appropiate (both Nocona and Opteron use x86 
model 15) 

-Andi

