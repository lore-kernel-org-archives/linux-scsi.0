From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH 1/2] Improve SCSI device type decoding
Date: Wed, 21 Jun 2006 14:02:35 -0400
Message-ID: <449989BB.1010205@torque.net>
References: <20060621165300.GX1630@parisc-linux.org>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:29836 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751108AbWFUSDo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Jun 2006 14:03:44 -0400
In-Reply-To: <20060621165300.GX1630@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

Matthew Wilcox wrote:
> Change API from the scsi_device_types array to the scsi_device_type function.
> Gets rid of a lot of common code, as well as being easier to use.  Also
> add the new device types in SPC4 r05a.

Not forgetting peripheral device types 1eh and 1fh
which are well known logical unit and unknown or
no device type respectively.

Reference: the bottom of table 84 in spc4r05a.pdf .

Well known logical units are out there, linux just
doesn't look for them (see the "select report" field
in REPORT LUNS command).
I have been told of special devices yielding pdf 1fh.

BTW I have tried to add these in the past but my patch
wasn't accepted.

Doug Gilbert
