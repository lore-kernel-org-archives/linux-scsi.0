From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] Print SCSI Inquiry data more compactly
Date: Wed, 21 Jun 2006 10:50:57 -0600
Message-ID: <20060621165057.GW1630@parisc-linux.org>
References: <547AF3BD0F3F0B4CBDC379BAC7E4189F0290B5BB@otce2k03.adaptec.com> <20060621164150.GM31472@vienna.egenera.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:41424 "EHLO
	palinux.external.hp.com") by vger.kernel.org with ESMTP
	id S932260AbWFUQu6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Jun 2006 12:50:58 -0400
Content-Disposition: inline
In-Reply-To: <20060621164150.GM31472@vienna.egenera.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Philip R. Auld" <pauld@egenera.com>
Cc: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>, dougg@torque.net, linux-scsi@vger.kernel.org

On Wed, Jun 21, 2006 at 12:41:50PM -0400, Philip R. Auld wrote:
> >     scsi 2:0:1:0: Device: DASD HP 18.2G ATLAS10K3_18_SCA HP05 ANSI ver: 02
> 
> Parsing this, (and the Matt's earlier version), there are 5 tokens
> there in the middle for 4 fields. How does one know what the vendor
> string is for example?

1) This is not for parsing, it's informational for users.  Do tools
really still parse through /var/log/dmesg?

2) This information is available other ways, such as through sysfs and
procfs.

3) I know it's not obvious from the above example (damn HP firmware),
but these are actually fixed-size fields.  The first is 8 bytes, "HP 18.2G"
the second 16 bytes are "ATLAS10K3_18_SCA", the third is "HP05" and then
the ANSI ver is at the end.
