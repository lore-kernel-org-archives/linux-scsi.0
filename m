From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 9/13] mpt2sas: T10 DIF Support - EEDP
Date: Thu, 16 Apr 2009 20:49:14 -0400
Message-ID: <yq1iql4w1dh.fsf@sermon.lab.mkp.net>
References: <20090416164514.GA4177@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet13.oracle.com ([148.87.113.125]:44243 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761281AbZDQAtc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Apr 2009 20:49:32 -0400
In-Reply-To: <20090416164514.GA4177@lsil.com> (Eric Moore's message of "Thu,
	16 Apr 2009 10:45:16 -0600")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric Moore <eric.moore@lsi.com>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org

>>>>> "Eric" == Eric Moore <eric.moore@lsi.com> writes:

Eric,

Eric> (1) I modified _scsih_setup_eedp so for TYPE1, its sets ref and
Eric>     gaurd checking, and for TYPE2 it sets gauard checking.

You mean Type 3 and not Type 2.  But yes, looks ok.

Feel free to add:

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
