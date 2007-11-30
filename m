From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: aic94xx or libsas crash on X7DB3 supermicro with enclosure and
	sata drives
Date: Fri, 30 Nov 2007 13:33:13 -0800
Message-ID: <20071130213313.GA7066@tree.beaverton.ibm.com>
References: <200711301022.08001.kb@sysmikro.com.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:39567 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667AbXK3VeF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Nov 2007 16:34:05 -0500
Received: from d03relay03.boulder.ibm.com (d03relay03.boulder.ibm.com [9.17.195.228])
	by e35.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id lAULY2VT008176
	for <linux-scsi@vger.kernel.org>; Fri, 30 Nov 2007 16:34:03 -0500
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay03.boulder.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id lAULXp5X168744
	for <linux-scsi@vger.kernel.org>; Fri, 30 Nov 2007 14:33:54 -0700
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id lAULXdkw024121
	for <linux-scsi@vger.kernel.org>; Fri, 30 Nov 2007 14:33:39 -0700
Content-Disposition: inline
In-Reply-To: <200711301022.08001.kb@sysmikro.com.pl>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Krzysztof B??aszkowski <kb@sysmikro.com.pl>
Cc: linux-scsi@vger.kernel.org, Vladislav Bolkhovitin <vlad@vlnb.net>, Alexis Bruemmer <alexisb@us.ibm.com>

On Fri, Nov 30, 2007 at 10:22:07AM +0100, Krzysztof B??aszkowski wrote:
> Hello all,
> 
> I noticed this according to syslog. furthermore if aic94xx is connected to 
> single sata drive only then there is no crash but device is not recognized 
> too. (mysterious: "ERROR: Unidentified device type 5").

There's been a substantial amount of bugfixes (as well as SATA support)
that went into the aic94xx/libsas code between .22 and .23; could you
please give that a try?

Also, what kind of devices are attached when the system crashes?  From
that stack trace it looks like the software thought there was a SATA
disk attached to an expander...?

--D
