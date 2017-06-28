From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [PATCH] ses: do not add a device to an enclosure if
 enclosure_add_links() fails.
Date: Tue, 27 Jun 2017 18:58:36 -0700
Message-ID: <1498615116.24122.33.camel@linux.vnet.ibm.com>
References: <1498557207-12364-1-git-send-email-mlombard@redhat.com>
         <yq1k23wzzly.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:44122 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752633AbdF1B6n (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Jun 2017 21:58:43 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v5S1wgwv136971
        for <linux-scsi@vger.kernel.org>; Tue, 27 Jun 2017 21:58:42 -0400
Received: from e17.ny.us.ibm.com (e17.ny.us.ibm.com [129.33.205.207])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2bc1mtk0ut-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 27 Jun 2017 21:58:42 -0400
Received: from localhost
        by e17.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <jejb@linux.vnet.ibm.com>;
        Tue, 27 Jun 2017 21:58:41 -0400
In-Reply-To: <yq1k23wzzly.fsf@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Maurizio Lombardi <mlombard@redhat.com>
Cc: linux-scsi@vger.kernel.org, dougmill@linux.vnet.ibm.com

On Tue, 2017-06-27 at 21:10 -0400, Martin K. Petersen wrote:
> Maurizio,
> 
> > 
> > The enclosure_add_device() function should fail if it can't
> > create the relevant sysfs links.
> 
> James?

It's essentially the patch I proposed, so I'm fine with it.  Although I
would like more root cause analysis about why we have this problem.

James
