From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [patch 20/28] drivers/message/fusion/linux_compat.h Removal of
 old code
Date: Tue, 26 Sep 2006 14:30:41 -0400
Message-ID: <451971D1.2040108@garzik.org>
References: <664A4EBB07F29743873A87CF62C26D7034FB86@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:31628 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1751574AbWIZSas (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Sep 2006 14:30:48 -0400
In-Reply-To: <664A4EBB07F29743873A87CF62C26D7034FB86@NAMAIL4.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsil.com>
Cc: akpm@osdl.org, James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, michal.k.k.piotrowski@gmail.com

Moore, Eric wrote:
> Jeff Garzik wrote:
> 
>> Why?  That's against the general kernel policy...
>>
>> As an example, when maintaining libata for 2.4 kernels as well as 2.6 
>> kernels, I had a libata-compat.h file, and always just patched the 
>> include into the kernel source at the same time I patched in the 
>> libata-compat.h contents.
>>
> 
> This is merely a request is all.
> Supporting Red Hat and SuSE distro's is why I ask. 
> I don't care about 2.4 kernel.  My compatibility 
> changes I support occur between 2.6 kernels releases, 
> such example is 2.6.17 and 2.6.18; e.g. SLES10 versus RHEL5
> with sas transport changes.  And they pull from upstream, 
> and I support them with interim bug fix's.

I'm not talking specifically about the 2.4 kernel, but making a 
comparison between upstream, and non-upstream back compat.  My example 
is clearly the same as your current situation.

I think most kernel devs would NAK keeping around an empty kernel header 
just for the sake of forked distro kernels.

	Jeff



