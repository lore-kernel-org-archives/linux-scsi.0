From: Benjamin Block <bblock@linux.vnet.ibm.com>
Subject: Re: [PATCH 00/22] zfcp fixes and cleanups
Date: Tue, 8 Aug 2017 12:02:24 +0200
Message-ID: <20170808100224.GA13050@bblock-ThinkPad-W530>
References: <cover.1501085249.git.bblock@linux.vnet.ibm.com>
 <yq13793b8j4.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:48779 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751921AbdHHKCa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Aug 2017 06:02:30 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v789wal4054255
        for <linux-scsi@vger.kernel.org>; Tue, 8 Aug 2017 06:02:30 -0400
Received: from e06smtp10.uk.ibm.com (e06smtp10.uk.ibm.com [195.75.94.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2c78u0yem3-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 08 Aug 2017 06:02:30 -0400
Received: from localhost
        by e06smtp10.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <bblock@linux.vnet.ibm.com>;
        Tue, 8 Aug 2017 11:02:27 +0100
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v78A2PaS23462044
        for <linux-scsi@vger.kernel.org>; Tue, 8 Aug 2017 10:02:25 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0EC15A4055
        for <linux-scsi@vger.kernel.org>; Tue,  8 Aug 2017 10:59:21 +0100 (BST)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E9769A4053
        for <linux-scsi@vger.kernel.org>; Tue,  8 Aug 2017 10:59:20 +0100 (BST)
Received: from bblock-ThinkPad-W530 (unknown [9.152.212.122])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP
        for <linux-scsi@vger.kernel.org>; Tue,  8 Aug 2017 10:59:20 +0100 (BST)
Content-Disposition: inline
In-Reply-To: <yq13793b8j4.fsf@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, Steffen Maier <maier@linux.vnet.ibm.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org

On Mon, Aug 07, 2017 at 01:19:11PM -0400, Martin K. Petersen wrote:
> > here is a series of (important) fixes and some additional cleanups for
> > the zfcp driver. Our fixes are marked for stable accordingly.
> >
> > Patches 01 - 04 are cleanups and external patches (also cleanups) that we
> >       & 13 - 22     had queued for quite some time now
> >
> > Patches 05 - 12 are driver fixes that are all marked for stable as well
> 
> Given the ordering, it's a bit unclear how you want me to apply these.
> 
> There are a bunch of fixes you labeled as "important" but they are not
> at the beginning of the series. And I am not sure if these have
> dependencies on the preceding cleanup patches?
> 
> If you have fixes you would like to get into 4.13, please post those
> first as a separate series. And clearly indicate that that's the branch
> you are aiming for.
> 
> If you are OK with everything going into 4.14, then let me know. In that
> case you don't have to shuffle the patches around.
> 

I think it is OK for us, if this goes into 4.14 as one series. So if it
is OK with you, just apply the complete series for that.

Thanks.



                                                    Beste Grüße / Best regards,
                                                      - Benjamin Block
-- 
Linux on z Systems Development         /         IBM Systems & Technology Group
		  IBM Deutschland Research & Development GmbH 
Vorsitz. AufsR.: Martina Koederitz     /        Geschäftsführung: Dirk Wittkopp
Sitz der Gesellschaft: Böblingen / Registergericht: AmtsG Stuttgart, HRB 243294
