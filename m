From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/7] smartpqi: add pqi reset quiesce support
Date: Wed, 16 Aug 2017 20:44:13 -0700
Message-ID: <1502941453.3589.22.camel@linux.vnet.ibm.com>
References: <150239072706.23771.1380444570336852695.stgit@brunhilda>
         <150239079917.23771.5169713749423377610.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:52535 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751549AbdHQDo3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 16 Aug 2017 23:44:29 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v7H3i3Mo011719
        for <linux-scsi@vger.kernel.org>; Wed, 16 Aug 2017 23:44:29 -0400
Received: from e18.ny.us.ibm.com (e18.ny.us.ibm.com [129.33.205.208])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ccwe79exf-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 16 Aug 2017 23:44:29 -0400
Received: from localhost
        by e18.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <jejb@linux.vnet.ibm.com>;
        Wed, 16 Aug 2017 23:44:28 -0400
In-Reply-To: <150239079917.23771.5169713749423377610.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@microsemi.com>, joseph.szczypek@hpe.com, gerry.morong@microsemi.com, john.hall@microsemi.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, bader.alisaleh@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, POSWALD@suse.com
Cc: linux-scsi@vger.kernel.org

On Thu, 2017-08-10 at 13:46 -0500, Don Brace wrote:
> From: Kevin Barnett <kevin.barnett@microseim.com>

To misspell someone else's company name could be considered unfortunate
... to misspell your own looks like carelessness.

You've done this twice, by the way.

James

> Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
> Signed-off-by: Kevin Barnett <kevin.barnett@microsemi.com>
> Signed-off-by: Don Brace <don.brace@microsemi.com>
