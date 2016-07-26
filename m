From: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/1] ipr: Wait to do async scan until scsi host is initialized
Date: Tue, 26 Jul 2016 11:07:36 -0300
Message-ID: <87d1m0o5lj.fsf@linux.vnet.ibm.com>
References: <20160715194804.89BFD2803D@b01ledav001.gho.pok.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:48252 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755802AbcGZOHn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Jul 2016 10:07:43 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u6QE3wEW091521
	for <linux-scsi@vger.kernel.org>; Tue, 26 Jul 2016 10:07:43 -0400
Received: from e24smtp01.br.ibm.com (e24smtp01.br.ibm.com [32.104.18.85])
	by mx0a-001b2d01.pphosted.com with ESMTP id 24dsrngvex-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 26 Jul 2016 10:07:42 -0400
Received: from localhost
	by e24smtp01.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <krisman@linux.vnet.ibm.com>;
	Tue, 26 Jul 2016 11:07:40 -0300
Received: from d24relay01.br.ibm.com (d24relay01.br.ibm.com [9.8.31.16])
	by d24dlp01.br.ibm.com (Postfix) with ESMTP id DC8D2352006E
	for <linux-scsi@vger.kernel.org>; Tue, 26 Jul 2016 10:07:18 -0400 (EDT)
Received: from d24av04.br.ibm.com (d24av04.br.ibm.com [9.8.31.97])
	by d24relay01.br.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u6QE7bx94931638
	for <linux-scsi@vger.kernel.org>; Tue, 26 Jul 2016 11:07:37 -0300
Received: from d24av04.br.ibm.com (localhost [127.0.0.1])
	by d24av04.br.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u6QE7bTh011536
	for <linux-scsi@vger.kernel.org>; Tue, 26 Jul 2016 11:07:37 -0300
In-Reply-To: <20160715194804.89BFD2803D@b01ledav001.gho.pok.ibm.com> (Brian
	King's message of "Fri, 15 Jul 2016 14:48:03 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

Brian King <brking@linux.vnet.ibm.com> writes:

> When performing an async scan, make sure the kthread doing scanning
> doesn't start before the scsi host is fully initialized.
>

Reviewed-by: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>

-- 
Gabriel Krisman Bertazi

