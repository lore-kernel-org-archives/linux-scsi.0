From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: SCSI testing/USB devices are amazing
Date: Thu, 09 May 2013 22:43:27 -0400
Message-ID: <yq1k3n7eer4.fsf@sermon.lab.mkp.net>
References: <CAN05THR+P7nzzTe6FCmG+F8_frkL=z-PS1GvoBVn57EyDMo-dw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:45049 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753389Ab3EJCnH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 May 2013 22:43:07 -0400
In-Reply-To: <CAN05THR+P7nzzTe6FCmG+F8_frkL=z-PS1GvoBVn57EyDMo-dw@mail.gmail.com>
	(ronnie sahlberg's message of "Sun, 28 Apr 2013 09:19:36 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ronnie sahlberg <ronniesahlberg@gmail.com>
Cc: linux-scsi@vger.kernel.org

>>>>> "Ronnie" == ronnie sahlberg <ronniesahlberg@gmail.com> writes:

Ronnie> * please have a look at the tests and the test results I linked
Ronnie>   to above. I currently have quite a few tests but am happy to
Ronnie>   add more.

Aside from issuing commands with various bits set, I'd like to see some
more sanity checking. Mainly to see whether it responds correctly to the
features is claims to support.

I.e. do the values reported in the Block Limits VPD look sane given what
we know about the device in general (SCSI level, capacity, PI supported,
discard supported, etc.)?

Right now you always expect RDPROTECT/WRPROTECT > 0 to fail, but they
should succeed if the device is formatted with PI.

FWIW, my slightly outdated document is here:

	https://oss.oracle.com/~mkp/docs/linux-advanced-storage.pdf

-- 
Martin K. Petersen	Oracle Linux Engineering
