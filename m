From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 14/15] lpfc 8.2.8 : Add statistical reporting control
	and additional fc vendor events
Date: Thu, 04 Sep 2008 16:35:13 -0500
Message-ID: <1220564113.9767.0.camel@localhost.localdomain>
References: <1219629035.7890.47.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:53841 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753979AbYIDVfQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Sep 2008 17:35:16 -0400
In-Reply-To: <1219629035.7890.47.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org

On Sun, 2008-08-24 at 21:50 -0400, James Smart wrote:
> Added support for new sysfs attributes: lpfc_stat_data_ctrl and
> lpfc_max_scsicmpl_time. The attributes control statistical reporting
> of io load.
> 
> Added support for new fc vendor events for error reporting.

Had to drop this too ... it's giving a compile error because it's using
a structure member introduced by 12/15

James


