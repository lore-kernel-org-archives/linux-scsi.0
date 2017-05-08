From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [PATCH] cxlflash: Select IRQ_POLL
Date: Mon, 8 May 2017 09:46:18 -0500
Message-ID: <36D9CEDE-1A42-42C7-9140-9D786C01752C@linux.vnet.ibm.com>
References: <1494027107-11234-1-git-send-email-linux@roeck-us.net>
Mime-Version: 1.0 (Mac OS X Mail 10.2 \(3259\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:40079 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754078AbdEHOqZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 May 2017 10:46:25 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v48EYDrD113512
        for <linux-scsi@vger.kernel.org>; Mon, 8 May 2017 10:46:24 -0400
Received: from e18.ny.us.ibm.com (e18.ny.us.ibm.com [129.33.205.208])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2aap5gmqa9-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 08 May 2017 10:46:24 -0400
Received: from localhost
        by e18.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
        Mon, 8 May 2017 10:46:23 -0400
In-Reply-To: <1494027107-11234-1-git-send-email-linux@roeck-us.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Guenter Roeck <linux@roeck-us.net>
Cc: "Manoj N . Kumar" <manoj@linux.vnet.ibm.com>, Uma Krishnan <ukrishn@linux.vnet.ibm.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

> On May 5, 2017, at 6:31 PM, Guenter Roeck <linux@roeck-us.net> wrote:
> 
> The driver now uses IRQ_POLL and needs to select it to avoid the following
> build error.
> 
> ERROR: ".irq_poll_complete" [drivers/scsi/cxlflash/cxlflash.ko] undefined!
> ERROR: ".irq_poll_sched" [drivers/scsi/cxlflash/cxlflash.ko] undefined!
> ERROR: ".irq_poll_disable" [drivers/scsi/cxlflash/cxlflash.ko] undefined!
> ERROR: ".irq_poll_init" [drivers/scsi/cxlflash/cxlflash.ko] undefined!
> 
> Fixes: cba06e6de403 ("scsi: cxlflash: Implement IRQ polling for RRQ processing")
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>

Acked-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
