From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Some interesting results in the aic7xxx slowdown problem
Date: Fri, 19 Aug 2005 09:22:45 -0400
Message-ID: <1124457765.5130.13.camel@mulgrave>
References: <1123119347.5019.78.camel@mulgrave>
	 <20050804061809.GA4158@in.ibm.com> <1123166928.5026.8.camel@mulgrave>
	 <20050819095428.GA9130@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([64.109.89.108]:4024 "EHLO
	accolon.hansenpartnership.com") by vger.kernel.org with ESMTP
	id S932658AbVHSNWy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Aug 2005 09:22:54 -0400
In-Reply-To: <20050819095428.GA9130@in.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: suparna@in.ibm.com
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, 2005-08-19 at 15:24 +0530, Suparna Bhattacharya wrote:
>  sda:

Well, this line is identifying the root cause.  It says that the
partition code came up with no partitions for this device.  Do any of
your other devices come up with paritions? (as in could this be a simple
device node transposition issue?)

James


