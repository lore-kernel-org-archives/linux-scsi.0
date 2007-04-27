From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH] aacraid: Initialize rx/rkt function pointers before calling
 them
Date: Fri, 27 Apr 2007 14:49:21 -0700
Message-ID: <46326FE1.1030605@us.ibm.com>
References: <AE4F746F2AECFC4DA4AADD66A1DFEF018FD9D2@otce2k301.adaptec.com>
Reply-To: "Darrick J. Wong" <djwong@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:56150 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757341AbXD0VtX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Apr 2007 17:49:23 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e6.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l3RLoHp0006840
	for <linux-scsi@vger.kernel.org>; Fri, 27 Apr 2007 17:50:17 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l3RLnMkj546826
	for <linux-scsi@vger.kernel.org>; Fri, 27 Apr 2007 17:49:22 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l3RLnLps012677
	for <linux-scsi@vger.kernel.org>; Fri, 27 Apr 2007 17:49:22 -0400
In-Reply-To: <AE4F746F2AECFC4DA4AADD66A1DFEF018FD9D2@otce2k301.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: linux-scsi@vger.kernel.org, Alexis Bruemmer <alexisb@us.ibm.com>, Vivek Goyal <vgoyal@in.ibm.com>, Judith Lebzelter <judith@linux-foundation.org>

Salyzyn, Mark wrote:
> As an option for a patch (later), what was the actual value of the
> Munit.OIMR register (on the x3550 and the x3650 please, just in case)?

0xF.

--D
