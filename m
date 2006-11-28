From: "Qi, Yanling" <Yanling.Qi@lsi.com>
Subject: remove_on_dev_loss module parameter in scsi_transport_fc
Date: Tue, 28 Nov 2006 11:01:53 -0700
Message-ID: <0F08E10B769EAF4EA2C43A573B8CC87F6DF9C2@NAMAIL3.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:61171 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S936001AbWK1SBz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Nov 2006 13:01:55 -0500
Received: from milmhbs0.lsil.com (mhbs.lsil.com [147.145.1.30])
	by mail0.lsil.com (8.12.8/8.12.8) with ESMTP id kASI0oG0015750
	for <linux-scsi@vger.kernel.org>; Tue, 28 Nov 2006 10:00:50 -0800 (PST)
Received: from namail.ad.lsil.com (namail.co.lsil.com [172.21.36.18])
	by milmhbs0.lsil.com (8.12.11/8.12.11) with ESMTP id kASI1wrp011347
	for <linux-scsi@vger.kernel.org>; Tue, 28 Nov 2006 10:01:58 -0800
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi All,

 

I saw SLES10 2.6.16.21-0.8-smp kernel supports a new module parameter
"remove_on_dev_loss" in scsi_transport_fc. The parameter description is

 

remove_on_dev_loss:Boolean.  When the device loss timer fires, this
variable controls whether the scsi infrastructure for the target device
is removed.  Values: zero means do not remove, non-zero means remove.
Default is zero. (int)

 

Seems this module parameter is not available in the upstream kernel. Is
this SUES' private module parameter or the upstream kernel will support
this parameter soon?

 

Thanks,

 

Yanling

 

Yanling Qi

Engenio Storage Group - LSI Logic

512-794-3713 (Office)

512-794-3702 (Fax)

yanling.qi@lsi.com

 

