From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH V2] mpt3sas: disable ASPM for MPI2 controllers
Date: Thu, 05 Jan 2017 20:54:14 -0500
Message-ID: <yq17f69hs1l.fsf@oracle.com>
References: <20161228110524.7516-1-ojab@ojab.ru>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:49472 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753564AbdAFBy3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Jan 2017 20:54:29 -0500
In-Reply-To: <20161228110524.7516-1-ojab@ojab.ru> (ojab@ojab.ru's message of
        "Wed, 28 Dec 2016 11:05:24 +0000")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ojab <ojab@ojab.ru>
Cc: Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

>>>>> "ojab" == ojab  <ojab@ojab.ru> writes:

ojab> MPI2 controllers sometimes got lost (i. e. disappears from
ojab> /sys/bus/pci/devices) if ASMP is enabled.

Broadcom folks: Please comment!

-- 
Martin K. Petersen	Oracle Linux Engineering
