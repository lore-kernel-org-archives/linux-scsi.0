From: Vijaya Mohan Guvva <vmohan@Brocade.com>
Subject: RE: [PATCH 7/8] bfa: Fix crash when symb name set for offline vport
Date: Tue, 3 Dec 2013 07:38:52 -0700
Message-ID: <51BD2AE8016AE441B63F5661159C990248D762F810@BRM-EXCH-3.corp.brocade.com>
References: <1384931146-3702-1-git-send-email-vmohan@brocade.com>
	 <1384931146-3702-8-git-send-email-vmohan@brocade.com>
 <1386081181.2166.37.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-000f0801.pphosted.com ([67.231.144.122]:42339 "EHLO
	mx0a-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753323Ab3LCOjE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Dec 2013 09:39:04 -0500
Received: from pps.filterd (m0000542 [127.0.0.1])
	by mx0a-000f0801.pphosted.com (8.14.5/8.14.5) with SMTP id rB3EWXDd000742
	for <linux-scsi@vger.kernel.org>; Tue, 3 Dec 2013 06:39:03 -0800
Received: from hq1wp-exchub02.corp.brocade.com ([144.49.131.13])
	by mx0a-000f0801.pphosted.com with ESMTP id 1ggxk5rye7-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 03 Dec 2013 06:39:03 -0800
In-Reply-To: <1386081181.2166.37.camel@dabdike.int.hansenpartnership.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Anil Gurumurthy <agurumur@Brocade.com>

> On Tue, 2013-11-19 at 23:05 -0800, vmohan@brocade.com wrote:
> > From: Vijaya Mohan Guvva <vmohan@brocade.com>
> >
> > This patch fixes a crash when tried setting symbolic name for an
> > offline vport through sysfs. Crash is due to uninitialized pointer
> > lport->ns, which gets initialized only on linkup (port online).
> 
> This looks like a separable patch that should go through the fixes tree to
> stable, is that right?
> 
> James
> 

Hi James,
Yes, this is a bug fix and should go through the fixes tree to stable tree.
So, should I separate this patch from the original patch and submit it separately?

Thanks,
Vijay
