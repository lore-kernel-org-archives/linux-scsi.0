From: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Subject: Re: [PATCH 3/4] scsi: remove eh_timed_out methods in the transport
 template
Date: Mon, 30 Jan 2017 14:26:41 -0800
Message-ID: <d1f074ed-7cca-b1b6-667e-f8dd738a5ce8@linux.vnet.ibm.com>
References: <1485778739-29036-1-git-send-email-hch@lst.de>
 <1485778739-29036-4-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:44528 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753046AbdA3W0q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 30 Jan 2017 17:26:46 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v0UMInIe133229
        for <linux-scsi@vger.kernel.org>; Mon, 30 Jan 2017 17:26:46 -0500
Received: from e38.co.us.ibm.com (e38.co.us.ibm.com [32.97.110.159])
        by mx0a-001b2d01.pphosted.com with ESMTP id 289sqxyafm-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 30 Jan 2017 17:26:46 -0500
Received: from localhost
        by e38.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <tyreld@linux.vnet.ibm.com>;
        Mon, 30 Jan 2017 15:26:45 -0700
In-Reply-To: <1485778739-29036-4-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On 01/30/2017 04:18 AM, Christoph Hellwig wrote:
> Instead define the timeout behavior purely based on the host_template
> eh_timed_out method and wire up the existing transport implementations
> in the host templates.  This also clears up the confusion that the
> transport template method overrides the host template one, so some
> drivers have to re-override the transport template one.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>


