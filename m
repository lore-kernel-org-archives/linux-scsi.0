From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: Please help if u can.
Date: Wed, 21 Feb 2007 12:55:26 -0800
Message-ID: <45DCB1BE.403@us.ibm.com>
References: <45DB9D89.7030804@tlchosting.com> <45DBD6CF.7010309@torque.net> <45DBE495.6050706@us.ibm.com> <45DC9053.10908@tlchosting.com>
Reply-To: "Darrick J. Wong" <djwong@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:51404 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423108AbXBUUze (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Feb 2007 15:55:34 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e31.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l1LKtVpm001739
	for <linux-scsi@vger.kernel.org>; Wed, 21 Feb 2007 15:55:31 -0500
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.2) with ESMTP id l1LKtV1o538318
	for <linux-scsi@vger.kernel.org>; Wed, 21 Feb 2007 13:55:31 -0700
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l1LKtUQt020649
	for <linux-scsi@vger.kernel.org>; Wed, 21 Feb 2007 13:55:31 -0700
In-Reply-To: <45DC9053.10908@tlchosting.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Scarpa <john@tlchosting.com>
Cc: dougg@torque.net, linux-scsi@vger.kernel.org, Alexis Bruemmer <alexisb@us.ibm.com>

John Scarpa wrote:
> First a very big thanks to all of u! I have been suffering a serious
> lack of sleep problem lately..  i should have noticed that by whom has
> been submitting the past 500 fixes and updates!
> 
> Quick question, is the driver still consider experimental??

Very much so.  The SAS bits are fairly stable nowadays, but the rest is
still YMWV. :)

> the guys i
> work with say it doesn't support sata drives and it's still experimental

SATA support is under development.  Patches exist in the git tree here:
http://www.kernel.org/git/?p=linux/kernel/git/jejb/aic94xx-sas-2.6.git;a=summary

> so don't use it.  And i can't find anything on the state of this driver.
> 
> PS.  I should have said i dropped that aic94xx-seq.fw in
> /lib,/lib/firmware,/lib64,/lib64/firmware  (still have yet to get this
> sucker to work)

Yes, you need a udev that's new enough to know how to handle the
firmware loading interface.  Typically, udev will load firmware from
/lib/firmware, though I suppose that depends on the distribution.  Not
sure if RH/Fedora support fw loading, newer Ubuntu-E and SuSE do...

--D
