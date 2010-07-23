From: Konrad Rzeszutek Wilk <konrad@darnok.org>
Subject: Re: [PATCH 15/19] be2iscsi: iscsi boot changes for the kernel
Date: Fri, 23 Jul 2010 09:22:25 -0400
Message-ID: <201007230922.29022.konrad@darnok.org>
References: <20100721225844.GA9750@serverengines.com> <4C48C44D.1060208@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from andromeda.dapyr.net ([206.212.254.10]:54233 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752644Ab0GWNYF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Jul 2010 09:24:05 -0400
In-Reply-To: <4C48C44D.1060208@cs.wisc.edu>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Jayamohan Kalickal <jayamohank@serverengines.com>, linux-scsi@vger.kernel.org, James.Bottomley@suse.de


> The only issue might be this patch. James, this patch is in Konrad's
> tree for 2.6.36:
> (it is actually 2 patches)
> http://git.kernel.org/?p=linux/kernel/git/konrad/ibft-2.6.git;a=commit;h=ba
>4ee30c6c797de148dcc7254cf6d531aba71d9b
> http://git.kernel.org/?p=linux/kernel/git/konrad/ibft-2.6.git;a=commit;h=b3
>3a84a384776fb2593dac4d77c72050f9e181b0
>
> So I am not sure who wants to send it upstream. I think as it is now,
> Konrad needs to send it because it depends on other patches in his tree.

I am planning on sending them to Linus the moments he announced that 2.6.35 is 
gold and he opens his merge window.
