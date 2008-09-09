From: "Sharon Geva" <sharon.geva75@gmail.com>
Subject: Is there an option to limit in FC-SCST the max size of data transfer?
Date: Tue, 9 Sep 2008 11:40:58 +0300
Message-ID: <ed9363010809090140tf64d6b2n7a2a3130852751eb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from qb-out-0506.google.com ([72.14.204.231]:55165 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753775AbYIIIlA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Sep 2008 04:41:00 -0400
Received: by qb-out-0506.google.com with SMTP id f11so3449669qba.17
        for <linux-scsi@vger.kernel.org>; Tue, 09 Sep 2008 01:40:59 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

I'm looking for a way to limit the size of max data transferred in a
single SCSI command when using FC-SCST (isp_scst).

Generally - using SCSI over FC in target mode - Is there a way for the
target device to declare what is the maximum size of IO data that it
is capable of receiving in a single SCSI command?
I know there is the 'block limits vpd page', which specifies the max
transfer size, however, I understand this page code is optional, so It
is not possible to rely on it.
Is it the FC layer that can communicate and enforce such a limit?

Is there any option in any of SCST modules to set this option?

Thanks in advance,

SG
