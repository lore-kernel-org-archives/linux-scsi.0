From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: ServeRAID ( ips ) 7.00.15 Driver Released
Date: Mon, 29 Mar 2004 12:19:21 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040329201921.GA996@beaverton.ibm.com>
References: <A121ABA5B472B74EB59076B8E3C8F0191D9790@rtpe2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.129]:23444 "EHLO
	e31.co.us.ibm.com") by vger.kernel.org with ESMTP id S263137AbUC2UT2
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Mar 2004 15:19:28 -0500
Content-Disposition: inline
In-Reply-To: <A121ABA5B472B74EB59076B8E3C8F0191D9790@rtpe2k01.adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: "Hammer, Jack" <Jack_Hammer@adaptec.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>

Jack,
	In future updates of the 2.6 ips driver could you consider adding
	the MODULE_VERSION macro. In case a modification is made to the
	driver and someone does not inc the version number the checksum
	diff would help point to some change in the source or help
	verify that the same source is being used.

-andmike
--
Michael Anderson
andmike@us.ibm.com

