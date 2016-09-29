From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/6] ipr: use pci_irq_allocate_vectors
Date: Thu, 29 Sep 2016 09:01:44 -0500
Message-ID: <200e5b3f-8555-9cd3-7940-0ec0f2867b95@linux.vnet.ibm.com>
References: <1473600688-24043-1-git-send-email-hch@lst.de>
 <1473600688-24043-3-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:41450 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1755085AbcI2OBx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 29 Sep 2016 10:01:53 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u8TE0Voj023981
        for <linux-scsi@vger.kernel.org>; Thu, 29 Sep 2016 10:01:52 -0400
Received: from e19.ny.us.ibm.com (e19.ny.us.ibm.com [129.33.205.209])
        by mx0b-001b2d01.pphosted.com with ESMTP id 25s34uukwy-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 29 Sep 2016 10:01:50 -0400
Received: from localhost
        by e19.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
        Thu, 29 Sep 2016 10:01:50 -0400
In-Reply-To: <1473600688-24043-3-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, hans.verkuil@cisco.com, brking@us.ibm.com, haver@linux.vnet.ibm.com, ching2048@areca.com.tw, axboe@fb.com, alex.williamson@redhat.com
Cc: kvm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, linux-media@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org

Thanks Christoph. Very nice. As I was reviewing the patch, I noticed
the additional PCI_IRQ_AFFINITY flag, which is currently not being set
in this patch. Is the intention to set that globally by default, or
should I follow up with a one liner to add that to the ipr driver
in the next patch set I send out?

Acked-by: Brian King <brking@linux.vnet.ibm.com>

Thanks,

Brian


-- 
Brian King
Power Linux I/O
IBM Linux Technology Center

