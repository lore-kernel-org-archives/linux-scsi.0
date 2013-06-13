From: Karel Zak <kzak@redhat.com>
Subject: Re: [PATCH] user_space_eject: unlock door before issuing CDROMEJECT
 command
Date: Thu, 13 Jun 2013 13:29:19 +0200
Message-ID: <20130613112919.GA26656@x2.net.home>
References: <51B04C93.8010508@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20545 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752088Ab3FML3X (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Jun 2013 07:29:23 -0400
Content-Disposition: inline
In-Reply-To: <51B04C93.8010508@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>
Cc: Michal Luscon <mluscon@redhat.com>, SCSI development list <linux-scsi@vger.kernel.org>, Aaron Lu <aaron.lwe@gmail.com>

On Thu, Jun 06, 2013 at 04:47:15PM +0800, Aaron Lu wrote:
> Hi Karel & Michal,
>  sys-utils/eject.c | 3 +++
>  1 file changed, 3 insertions(+)

 Applied, thanks.

-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com
