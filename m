From: Ewan Milne <emilne@redhat.com>
Subject: Re: iSCSI regression with linux 3.9 and 4.0
Date: Fri, 20 Mar 2015 11:08:03 -0400
Message-ID: <1426864083.19806.66.camel@localhost.localdomain>
References: <20150320135742.63df219b@leda.localdomain>
	 <1426859486.19806.30.camel@localhost.localdomain>
	 <20150320153104.086f3b46@leda.localdomain>
	 <1426863883.19806.65.camel@localhost.localdomain>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57365 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750777AbbCTPIM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Mar 2015 11:08:12 -0400
In-Reply-To: <1426863883.19806.65.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christian Hesse <list@eworm.de>
Cc: linux-scsi@vger.kernel.org

On Fri, 2015-03-20 at 11:04 -0400, Ewan Milne wrote:
> Does your target support the Block Limits VPD (page B0)?  (i.e. can
> you run "sg_inq /dev/sda -p bl" from the sg3_utils package?)
> 

I meant /dev/sdb, sorry.


