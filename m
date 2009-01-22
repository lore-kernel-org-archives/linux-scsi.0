From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: RE: qla2xxx 0000:03:0c.0: Firmware image unavailable
Date: Thu, 22 Jan 2009 08:56:05 -0600
Message-ID: <1232636165.3569.0.camel@localhost.localdomain>
References: <1225944321.14830.1109.camel@chandra-ubuntu>
	 <E463DF2B2E584B4A82673F53D62C2EF45CEAB48E@cosmail01.lsi.com>
	 <39FF78AD-75CB-4495-99C7-C4FAFB23999D@qlogic.com>
	 <E463DF2B2E584B4A82673F53D62C2EF45CEAB550@cosmail01.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:49150 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751070AbZAVO4I (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Jan 2009 09:56:08 -0500
In-Reply-To: <E463DF2B2E584B4A82673F53D62C2EF45CEAB550@cosmail01.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moger, Babu" <Babu.Moger@lsi.com>
Cc: Seokmann Ju <seokmann.ju@qlogic.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>

On Thu, 2009-01-22 at 07:14 -0700, Moger, Babu wrote:
> Yes, the naming conventions look good. Here is the output of ls
> 
> -rw-r--r-- 1 root root  76802 Jan 21 16:41 ql2100_fw.bin
> -rw-r--r-- 1 root root  84566 Jan 21 16:41 ql2200_fw.bin
> -rw-r--r-- 1 root root 125088 Jan 21 16:41 ql2300_fw.bin
> -rw-r--r-- 1 root root 135896 Jan 21 16:41 ql2322_fw.bin
> -rw-r--r-- 1 root root 228056 Jan 21 16:41 ql2400_fw.bin
> -rw-r--r-- 1 root root 239052 Jan 21 16:41 ql2400_fw.bin_mid
> -rw-r--r-- 1 root root 200064 Jan 21 16:41 ql2500_fw.bin
> -rw-r--r-- 1 root root 219924 Jan 21 16:41 ql2500_fw.bin_mid

OK, so logical choice number 2 is that udev, which feeds the firmware
into the kernel, isn't working for you.  This is really a distribution
problem.

James


