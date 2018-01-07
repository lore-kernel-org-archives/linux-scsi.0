From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [PATCH 5/6] cxlflash: Adapter context init can return error
Date: Sun, 7 Jan 2018 13:42:06 -0600
Message-ID: <20180107194206.GD45065@p8tul1-build.aus.stglabs.ibm.com>
References: <1515020002-43551-1-git-send-email-ukrishn@linux.vnet.ibm.com>
 <1515020104-43758-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:60446 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754356AbeAGTmM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Jan 2018 14:42:12 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.22/8.16.0.21) with SMTP id w07JfmPb067700
        for <linux-scsi@vger.kernel.org>; Sun, 7 Jan 2018 14:42:12 -0500
Received: from e18.ny.us.ibm.com (e18.ny.us.ibm.com [129.33.205.208])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2fbfxpfnyc-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Sun, 07 Jan 2018 14:42:12 -0500
Received: from localhost
        by e18.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
        Sun, 7 Jan 2018 14:42:11 -0500
Content-Disposition: inline
In-Reply-To: <1515020104-43758-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

On Wed, Jan 03, 2018 at 04:55:04PM -0600, Uma Krishnan wrote:
> Adapter context creation can return either NULL or an error pointer.
> Updating the check condition to reflect this.
> 
> Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>

Acked-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
