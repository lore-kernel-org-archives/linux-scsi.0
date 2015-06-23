From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: configurable discard parameters
Date: Tue, 23 Jun 2015 14:26:18 -0400
Message-ID: <yq1egl246yd.fsf@sermon.lab.mkp.net>
References: <CAGnHSEmDQ6xaJsw9i=v23BffWQ8RncrgNBsGWy3ziC36QK+9yQ@mail.gmail.com>
	<yq1fv5l9ajd.fsf@sermon.lab.mkp.net>
	<CAGnHSEk+=r1CwQaGd9n4nUm3_e3O7GOL_iFDeJTuNyaSq9WFYg@mail.gmail.com>
	<CAGnHSEnevg=advtq=CW2FvV5b93GX3kNwrFu587O2V7hf1J8hA@mail.gmail.com>
	<CAGnHSEnBvgWKw6g=c4vpCNEfpdh_45orz5JcSmfM7jadxjpxzQ@mail.gmail.com>
	<CAGnHSEnLACL6XisaFn3axRETAD3CjOa7fGrHKR7s6GOroQXkew@mail.gmail.com>
	<yq1616f796w.fsf@sermon.lab.mkp.net>
	<CAGnHSEn4EPC_RHTJXtvFC8dj8L+aDd_pRvSsDWNaqHz3Tdxj5w@mail.gmail.com>
	<yq1bng65te8.fsf@sermon.lab.mkp.net>
	<CAGnHSEm89yFPPTVUtbk1s84wanKK6RTY5hdZCMdbw+a+vwecDA@mail.gmail.com>
	<yq1mvzq4at7.fsf@sermon.lab.mkp.net>
	<CAGnHSEkF+uXh2=wpq9dwjK8_NrjF5kqcasXeuCF_=TONu6Q7Cw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:26171 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933116AbbFWS0W (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Jun 2015 14:26:22 -0400
In-Reply-To: <CAGnHSEkF+uXh2=wpq9dwjK8_NrjF5kqcasXeuCF_=TONu6Q7Cw@mail.gmail.com>
	(Tom Yan's message of "Wed, 24 Jun 2015 01:24:12 +0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tom Yan <tom.ty89@gmail.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org

>>>>> "Tom" == Tom Yan <tom.ty89@gmail.com> writes:

Tom> So when libata issue ATA commands with ranges of 65535 sectors,
Tom> only 65535-(65535%8) = 65528 sectors are discarded,

That's unfortunate but TRIM is advisory so the drive is free to ignore
all or parts of the request.

What happens if you discard sectors 0-6 and then sector 7?

Tom> I can workaround this by specifying --step in blkdiscard, but I
Tom> think the kernel should have a param configurable for general.

This is on the Intel 530? What does the drive report in
/sys/block/sdN/queue/discard_zeroes_data?

-- 
Martin K. Petersen	Oracle Linux Engineering
