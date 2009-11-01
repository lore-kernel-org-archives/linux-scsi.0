From: Martin Michlmayr <tbm@cyrius.com>
Subject: Re: [PATCH] Add missing #include for include/scsi/osd_protocol.h
Date: Sun, 1 Nov 2009 10:54:16 +0000
Message-ID: <20091101105416.GN20819@deprecation.cyrius.com>
References: <20091031093337.GA3339@deprecation.cyrius.com>
 <4AED5FBF.6020308@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sorrow.cyrius.com ([65.19.161.204]:57394 "EHLO
	sorrow.cyrius.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446AbZKAKyV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 1 Nov 2009 05:54:21 -0500
Content-Disposition: inline
In-Reply-To: <4AED5FBF.6020308@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org

* Boaz Harrosh <bharrosh@panasas.com> [2009-11-01 12:15]:
> > include/scsi/osd_protocol.h is missing an #include, leading to:
> > | include/scsi/osd_protocol.h:277: error: implicit declaration of function '__constant_cpu_to_be16'
> > | include/scsi/osd_protocol.h:362: error: implicit declaration of function 'ALIGN'
> 
> I cannot reproduce this problem. What platform  (ARCH/config) are you compiling
> this?

Sorry, I forgot to say that this happens on ARM.
-- 
Martin Michlmayr
http://www.cyrius.com/
