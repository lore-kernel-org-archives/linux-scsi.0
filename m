From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: Async scan changes -- now available as a git tree
Date: Wed, 15 Nov 2006 16:13:53 -0800
Message-ID: <455BAD41.5000502@us.ibm.com>
References: <20061115235324.GN19143@parisc-linux.org> <1163635387.3524.20.camel@mulgrave.il.steeleye.com>
Reply-To: "Darrick J. Wong" <djwong@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:9705 "EHLO e36.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S1162094AbWKPAN4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Nov 2006 19:13:56 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e36.co.us.ibm.com (8.13.8/8.12.11) with ESMTP id kAG0DsBl013124
	for <linux-scsi@vger.kernel.org>; Wed, 15 Nov 2006 19:13:54 -0500
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay04.boulder.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id kAG0DsgZ322700
	for <linux-scsi@vger.kernel.org>; Wed, 15 Nov 2006 17:13:54 -0700
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id kAG0DsTi000422
	for <linux-scsi@vger.kernel.org>; Wed, 15 Nov 2006 17:13:54 -0700
In-Reply-To: <1163635387.3524.20.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org

James Bottomley wrote:

> OK, here's the error case fix I needed ... 

jejb: This is the patch in aic94xx-sas, correct?

willy: This patch was already applied to the kernel that I tested for
you this morning, assuming that the answer to the previous question is
"yes".

--D
