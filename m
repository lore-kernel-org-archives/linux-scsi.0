From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 0082/1285] Replace numeric parameter like 0444 with macro
Date: Tue, 02 Aug 2016 10:42:49 -0400
Message-ID: <1470148969.2485.20.camel@HansenPartnership.com>
References: <20160802103914.19225-1-baolex.ni@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:56110 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965647AbcHBOzg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Aug 2016 10:55:36 -0400
In-Reply-To: <20160802103914.19225-1-baolex.ni@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Baole Ni <baolex.ni@intel.com>, don.brace@microsemi.com, len.brown@intel.com, pavel@ucw.cz, gregkh@linuxfoundation.org, hpa@zytor.com, x86@kernel.org
Cc: iss_storagedev@hp.com, esc.storagedev@microsemi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, chuansheng.liu@intel.com

On Tue, 2016-08-02 at 18:39 +0800, Baole Ni wrote:
> I find that the developers often just specified the numeric value
> when calling a macro which is defined with a parameter for access 
> permission. As we know, these numeric value for access permission 
> have had the corresponding macro, and that using macro can improve 
> the robustness and readability of the code, thus, I suggest replacing
> the numeric parameter with the macro.

Please stop ... can't you see that sending out over a thousand emails
with a single change in each is basically spam, especially for those of
us who got our INBOXes filled by virtue of being on the direct cc.  You
don't need the thousand emails to achieve agreement over whether we
should do this, and if we decide to do it, Linus would far rather run a
simple script over the kernel as it is in an -rc state.  Could you
please begin a discussion by posting the suggestion and the script.

Thanks,

James

