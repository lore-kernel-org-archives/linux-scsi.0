From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH] 2.6 aacraid: Add sysfs files for aacraid adapter information (re-diff)
Date: Tue, 24 May 2005 07:35:19 -0400
Message-ID: <60807403EABEB443939A5A7AA8A7458B0132BA29@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:31715 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S261986AbVEXLf0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 May 2005 07:35:26 -0400
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matt Domsch <Matt_Domsch@dell.com>, Mark Haverkamp <markh@osdl.org>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>

Matt Domsch writes:
> That's what others do (ethtool -i), so seems sane if you really need
> it exported in sysfs before the above is merged.  What's the rush
> though?  If it can wait a release, I'll push on the above then it'll
> be there for all modules.

The 'rush' is pressure from OEMs for management tools that function with
the 'in-box' driver. Today is a day for sarcasm it appears :->

I'll direct the management software team to use the sys entry exported
by your patch, we can drop the host_version requirement from the driver
...

-- Mark Salyzyn
