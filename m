From: Christoph Hellwig <hch@infradead.org>
Subject: Re: PATCH [6/5]  qla2xxx: update version :)
Date: Tue, 19 Apr 2005 22:15:19 +0100
Message-ID: <20050419211519.GB20234@infradead.org>
References: <20050413205007.GA14857@plap.qlogic.org> <1113425828.4933.39.camel@mulgrave> <20050413212436.GC14857@plap.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:59270 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261689AbVDSVPU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Apr 2005 17:15:20 -0400
Content-Disposition: inline
In-Reply-To: <20050413212436.GC14857@plap.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, Patrick Mansfield <patmans@us.ibm.com>

On Wed, Apr 13, 2005 at 02:24:36PM -0700, Andrew Vasquez wrote:
> Ok, here's the deal -- QLogic's standard 8.01.00 driver contains the
> following major additions:
> 
> * support for 4Gb ISPs
> * FCIP support

Btw, any plans to do proper FCIP support integrated with the transport
class code?  (and finally fixing the damn NAA bug violating RFC 2625 ;-))
