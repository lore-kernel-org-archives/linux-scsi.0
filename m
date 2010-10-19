From: Jing Huang <huangj@Brocade.COM>
Subject: RE: [PATCH 2/6] bfa: replace endian swap macros with the ones
 provided by linux
Date: Tue, 19 Oct 2010 13:14:53 -0700
Message-ID: <E5313AF6F2BFD14293E5FD0F94750F86A5CF75E89A@HQ1-EXCH01.corp.brocade.com>
References: <1287447050-27777-1-git-send-email-huangj@brocade.com>
 <20101019140920.GA13348@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:44407 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752686Ab0JSUPJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Oct 2010 16:15:09 -0400
In-Reply-To: <20101019140920.GA13348@infradead.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "James.Bottomley@suse.de" <James.Bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Adapter Linux Open SRC Team <adapter_linux_open_src_team@Brocade.COM>

>Is this enough that
>
>	make C=2 CF="-D__CHECK_ENDIAN__"
>
>gives you clean enough output to actually verify all the endiness
>conversions?

Thanks for reviewing the patch. I tried sparse endianess checking and saw a lot of warnings, mostly
because the structure members are still declared as unsigned int instead of using endianess annotated
types such as __le16, __be16 and etc. Are issues like this must be fixed? I tried some other drivers
and saw a lot of similar issues also.

