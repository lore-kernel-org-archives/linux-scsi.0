From: Christoph Hellwig <hch@infradead.org>
Subject: Re: PATCH [6/8]  qla2xxx: Small enhancements
Date: Tue, 7 Sep 2004 08:38:02 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040907083802.A12964@infradead.org>
References: <20040907042904.GA29651@praka.san.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imladris.demon.co.uk ([193.237.130.41]:20487 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S267520AbUIGHiF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Sep 2004 03:38:05 -0400
Content-Disposition: inline
In-Reply-To: <20040907042904.GA29651@praka.san.rr.com>; from andrew.vasquez@qlogic.com on Mon, Sep 06, 2004 at 09:29:04PM -0700
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>

On Mon, Sep 06, 2004 at 09:29:04PM -0700, Andrew Vasquez wrote:
> ChangeSet
>   1.1876 04/09/06 11:57:40 andrew.vasquez@qlogic.com +4 -0
>   Misc. small enhancements:
>   
>           o Add 're-scan' and 'initiate lip' support via /proc
>             similar to the 7.x series drivers.

procfs support is deprecated, any new procfs invofmration is
explicitly vetoed.  These changes need to go into sysfs, please
try to work with emulex to get these attributes into the fc
transport class.

