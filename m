From: Pat LaVarre <p.lavarre@ieee.org>
Subject: zip of GiB cross-platform
Date: 29 Sep 2003 13:39:39 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1064864378.4262.53.camel@patehci2>
References: <1064271322.4797.9.camel@patehci2>
	 <1064847281.24854.2.camel@patehci2>  <1064850600.25057.7.camel@patehci2>
	 <1064858121.4262.0.camel@patehci2>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:54517 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S264595AbTI2TjV
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Sep 2003 15:39:21 -0400
Received: from royntex01.iomegacorp.com (unknown [147.178.90.120])
	by email.iomega.com (Postfix) with ESMTP id F169419F9
	for <linux-scsi@vger.kernel.org>; Mon, 29 Sep 2003 13:39:20 -0600 (MDT)
In-Reply-To: <1064858121.4262.0.camel@patehci2>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Is linux-scsi a place where folk hang out who often mail around GiB from
Linux?

I see Linux `zip -r $folder $folder` produces .zip files that Mac OS X
and Win XP can read ...

... only when the folder is small.  When the folder contains a `dd`
image of a mostly zero 1GiB disk (specifically an initially zero +
`mkudffs`) disk, then Mac OS X & Win XP choke.

`unzip -vt $folder` is happy, `unzip` produces a file that `diff` and
`cmp` say matches the original.

Did I commit some brain dead newbie error?  Reproduce a known bug? 
Discover a new bug?

Pat LaVarre

P.S. For example, Mac OS X reports:

An error has occurred while expanding the file ...zlxudf.zip"
(Unspecified StuffIt Engine internal error).

Error #17999


