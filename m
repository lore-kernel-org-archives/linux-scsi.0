From: Steven Pratt <slpratt@austin.ibm.com>
Subject: Re: MPTSAS Driver and scatter gather lists
Date: Tue, 04 Dec 2007 16:48:23 -0600
Message-ID: <4755D937.7000209@austin.ibm.com>
References: <664A4EBB07F29743873A87CF62C26D70BA6CA6@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:55133 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751458AbXLDWsb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Dec 2007 17:48:31 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e6.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id lB4Mo5wt008886
	for <linux-scsi@vger.kernel.org>; Tue, 4 Dec 2007 17:50:05 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id lB4MmNCb476964
	for <linux-scsi@vger.kernel.org>; Tue, 4 Dec 2007 17:48:23 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id lB4MmMO7016557
	for <linux-scsi@vger.kernel.org>; Tue, 4 Dec 2007 17:48:23 -0500
In-Reply-To: <664A4EBB07F29743873A87CF62C26D70BA6CA6@NAMAIL4.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsi.com>
Cc: linux-scsi@vger.kernel.org

Moore, Eric wrote:
> On Tuesday, December 04, 2007 8:45 AM,  Steven Pratt wrote:
>   
>> Also, is there any reason we can't increase sg_tablesize for mptsas?
>>
>>     
>
> The default 128, set in Kconfig (look at FUSION_MAX_SGE).    It only set
> to 40 when that is not defined.  What is in your kernel .config, e.g
> look for CONFIG_FUSION_MAX_SGE.
>   

RHEL5 x86_64 has this:

 >grep CONFIG_FUSION_MAX_SGE /boot/config-2.6.18-8.el5
CONFIG_FUSION_MAX_SGE=40

Steve
> Eric
>   

