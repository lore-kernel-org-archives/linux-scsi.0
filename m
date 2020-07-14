Return-Path: <SRS0=xC/A=AZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7A01C433E2
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 12:03:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B68D722224
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 12:03:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728125AbgGNMDJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Jul 2020 08:03:09 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:7974 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726630AbgGNMDJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 14 Jul 2020 08:03:09 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06EC2Qmg176028;
        Tue, 14 Jul 2020 08:03:04 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32792v2fwf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Jul 2020 08:03:02 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06EBxrFW022974;
        Tue, 14 Jul 2020 12:02:47 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03fra.de.ibm.com with ESMTP id 327527hnxu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Jul 2020 12:02:47 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06EC2iKf61603916
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jul 2020 12:02:44 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6FDCA52069;
        Tue, 14 Jul 2020 12:02:44 +0000 (GMT)
Received: from t480-pf1aa2c2 (unknown [9.145.164.206])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id 66FDF52067;
        Tue, 14 Jul 2020 12:02:44 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2 with local (Exim 4.94)
        (envelope-from <bblock@linux.ibm.com>)
        id 1jvJdz-001SDG-E6; Tue, 14 Jul 2020 14:02:43 +0200
Date:   Tue, 14 Jul 2020 14:02:42 +0200
From:   Benjamin Block <bblock@linux.ibm.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Steffen Maier <maier@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Fedor Loshakov <loshakov@linux.ibm.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 3/3] scsi: Rename slave_configure to sdev_configure
Message-ID: <20200714120242.GC7244@t480-pf1aa2c2>
References: <20200706193920.6897-1-willy@infradead.org>
 <20200706193920.6897-4-willy@infradead.org>
 <20200714082631.GB7244@t480-pf1aa2c2>
 <20200714114122.GA12769@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200714114122.GA12769@casper.infradead.org>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-14_03:2020-07-14,2020-07-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 mlxlogscore=999 priorityscore=1501 lowpriorityscore=0 clxscore=1015
 adultscore=0 impostorscore=0 spamscore=0 malwarescore=0 bulkscore=0
 mlxscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007140085
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Jul 14, 2020 at 12:41:22PM +0100, Matthew Wilcox wrote:
> On Tue, Jul 14, 2020 at 10:26:31AM +0200, Benjamin Block wrote:
> > > @@ -428,7 +428,7 @@ static struct scsi_host_template zfcp_scsi_host_template = {
> > >  	.eh_target_reset_handler = zfcp_scsi_eh_target_reset_handler,
> > >  	.eh_host_reset_handler	 = zfcp_scsi_eh_host_reset_handler,
> > >  	.sdev_prep		 = zfcp_scsi_sdev_prep,
> > > -	.slave_configure	 = zfcp_scsi_slave_configure,
> > > +	.sdev_configure	 = zfcp_scsi_sdev_configure,
> > 
> > Please fix the alignment.
> 
> sed doesn't kow how to do that.

So? We have been able to maintain it so far without sed being able to do
it.

I don't mean to be snarky or anything, but I don't see why we can't have
this respect the code-base we have so far.

-- 
Best Regards, Benjamin Block  / Linux on IBM Z Kernel Development / IBM Systems
IBM Deutschland Research & Development GmbH    /    https://www.ibm.com/privacy
Vorsitz. AufsR.: Gregor Pillen         /        Geschäftsführung: Dirk Wittkopp
Sitz der Gesellschaft: Böblingen / Registergericht: AmtsG Stuttgart, HRB 243294
