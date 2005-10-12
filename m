From: "Graham" <graham@soundclashchampions.com>
Subject: aacraid version confusion
Date: Wed, 12 Oct 2005 10:24:06 -0700 (PDT)
Message-ID: <4504.69.15.46.10.1129137846.squirrel@69.15.46.10>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gnosis.slac.com ([208.185.215.36]:49872 "EHLO slac.com")
	by vger.kernel.org with ESMTP id S932444AbVJLRYG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Oct 2005 13:24:06 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I'm thoroughly confused about the versioning of the aacraid driver, and
would very much appreciate it if someone could explain to me how it works.

Firstly, I've found that the source for the aacraid driver differs vastly
between kernels 2.6.8 and 2.6.13, yet both have the driver labeled as
version "1.1.2-lk2".  If the code changed, shouldn't the version label
change?

Secondly, I don't understand what the 1.1.5 line is.  Where is the source
code kept?  Is it actively merged into the mainline kernel source?  I found
version 1.1.5-2326 on adaptec.com, seen talk of 1.1.5-2345 on this list, and
found 1.1.5-2392 on dell.com.

Thirdly, what is considered the latest "stable" version?

Thanks in advance,
  Graham


