From: Vijaya Mohan Guvva <vmohan@Brocade.com>
Subject: RE: [PATCH] [SCSI] bfa: fix missing unlock on error in
 bfad_iocmd_cfg_trunk()
Date: Mon, 23 Dec 2013 01:11:34 -0700
Message-ID: <51BD2AE8016AE441B63F5661159C99024A51E75C48@BRM-EXCH-3.corp.brocade.com>
References: <CAPgLHd9prpLF_sjwoj_QmiAZtwQG=Yig2FsYgd2OE5HXHpb04A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:11470 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757007Ab3LWILk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Dec 2013 03:11:40 -0500
Received: from pps.filterd (m0000700 [127.0.0.1])
	by mx0b-000f0801.pphosted.com (8.14.5/8.14.5) with SMTP id rBN7aOFv007531
	for <linux-scsi@vger.kernel.org>; Mon, 23 Dec 2013 00:11:39 -0800
Received: from hq1wp-exchub01.corp.brocade.com ([144.49.131.13])
	by mx0b-000f0801.pphosted.com with ESMTP id 1gvmdn4kum-4
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 23 Dec 2013 00:11:39 -0800
In-Reply-To: <CAPgLHd9prpLF_sjwoj_QmiAZtwQG=Yig2FsYgd2OE5HXHpb04A@mail.gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Wei Yongjun <weiyj.lk@gmail.com>, Anil Gurumurthy <agurumur@Brocade.com>, "JBottomley@parallels.com" <JBottomley@parallels.com>
Cc: "yongjun_wei@trendmicro.com.cn" <yongjun_wei@trendmicro.com.cn>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

> -----Original Message-----
> From: Wei Yongjun [mailto:weiyj.lk@gmail.com]
> Sent: Friday, December 20, 2013 8:21 AM
> To: Anil Gurumurthy; Vijaya Mohan Guvva; JBottomley@parallels.com
> Cc: yongjun_wei@trendmicro.com.cn; linux-scsi@vger.kernel.org
> Subject: [PATCH] [SCSI] bfa: fix missing unlock on error in
> bfad_iocmd_cfg_trunk()
> 
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Add the missing unlock before return from function bfad_iocmd_cfg_trunk()
> in the error handling case.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  drivers/scsi/bfa/bfad_bsg.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

Looks fine, thanks, Vijay
Acked-by: Vijaya Mohan Guvva <vmohan@brocade.com>

