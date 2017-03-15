From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [PATCH V3 2/3] hpsa: limit outstanding rescans
Date: Wed, 15 Mar 2017 10:23:39 -0700
Message-ID: <1489598619.2387.22.camel@linux.vnet.ibm.com>
References: <148917802486.17050.17178463722401202189.stgit@brunhilda>
         <148917811749.17050.10796225321668028334.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:45715 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751014AbdCORXw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 15 Mar 2017 13:23:52 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v2FHNfOs130884
        for <linux-scsi@vger.kernel.org>; Wed, 15 Mar 2017 13:23:50 -0400
Received: from e13.ny.us.ibm.com (e13.ny.us.ibm.com [129.33.205.203])
        by mx0b-001b2d01.pphosted.com with ESMTP id 296nfyrm3f-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 15 Mar 2017 13:23:50 -0400
Received: from localhost
        by e13.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <jejb@linux.vnet.ibm.com>;
        Wed, 15 Mar 2017 13:23:49 -0400
In-Reply-To: <148917811749.17050.10796225321668028334.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@microsemi.com>, joseph.szczypek@hpe.com, gerry.morong@microsemi.com, john.hall@microsemi.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, bader.alisaleh@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, POSWALD@suse.com
Cc: linux-scsi@vger.kernel.org

On Fri, 2017-03-10 at 14:35 -0600, Don Brace wrote:
> avoid rescan storms. No need to queue another
> if one is pending.
> 
> Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
> Reviewed-by: Scott Teel <scott.teel@microsemi.com>
> Reviewed-by: Tomas Henzl <thenzl@redhat.com> review

Guys, what is this additional "review" for?  I just noticed because my
reply scripts barfed on it.  Please don't add extra junk after an email
address in a tag line.

Thanks,

James
