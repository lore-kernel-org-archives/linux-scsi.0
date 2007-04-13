From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: RAID1 can't be written after pulling out the secondary hard disk
Date: Fri, 13 Apr 2007 13:53:59 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D706BF8E0@NAMAIL4.ad.lsil.com>
References: <ac8af0be0704100200v63194731i91c9125ff7bff951@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:62468 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932140AbXDMTyS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Apr 2007 15:54:18 -0400
Content-class: urn:content-classes:message
In-Reply-To: <ac8af0be0704100200v63194731i91c9125ff7bff951@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Zhao Forrest <forrest.zhao@gmail.com>
Cc: mpt_linux_developer@lsi.com, linux-scsi@vger.kernel.org, "Support, Software" <support@lsi.com>

On Tuesday, April 10, 2007 3:01 AM,  Zhao Forrest wrote: 

> Hi Eric,
> We conducted the following test on a SUN Galaxy x64 server, then RAID1
> can't be written anymore, fs become read-only. The steps of
> reproducing the bug:

I sent you earlier a patch via Novell Bugzilla 244006.   Please let me
know if this satisfies your needs, then I will post a port of that patch
here to lsml@.

Eric
