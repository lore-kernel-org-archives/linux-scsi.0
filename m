From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: scsi_dh_alua: Retry the check-condition in case Mode Parameters
 Changed
Date: Tue, 10 Jan 2012 15:50:40 -0500
Message-ID: <20120110205040.GA7632@redhat.com>
References: <47D23AD8469A2B448F33C24BD7A39BD910D14606@RTPMVEXC1-PRD.hq.netapp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53473 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756672Ab2AJUvZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Jan 2012 15:51:25 -0500
Content-Disposition: inline
In-Reply-To: <47D23AD8469A2B448F33C24BD7A39BD910D14606@RTPMVEXC1-PRD.hq.netapp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moger, Babu" <Babu.Moger@netapp.com>
Cc: linux-scsi@vger.kernel.org, dm-devel@redhat.com, JBottomley@Parallels.com

On Wed, Dec 21 2011 at  6:01pm -0500,
Moger, Babu <Babu.Moger@netapp.com> wrote:

> This patch adds a check-condition in scsi_dh_alua handler for a retry.
> Sometimes,
> I have seen attach failing due to this check-condition with following
> error 
> messages on NetApp E series storage.
> 
> Dec  7 15:31:01 nilgiris kernel: [102979.696673] scsi 3:0:2:9: alua:
> port group 00 rel port 01
> Dec  7 15:31:01 nilgiris kernel: [102979.697082] scsi 3:0:2:9: alua:
> rtpg failed with 8000002
> Dec  7 15:31:01 nilgiris kernel: [102979.697086] scsi 3:0:2:9: alua:
> rtpg sense code 06/2a/01
> Dec  7 15:31:01 nilgiris kernel: [102979.697088] scsi 3:0:2:9: alua: not
> attached
> 
> Signed-off-by: Babu Moger <babu.moger@netapp.com>

Babu, this patch is malformed due to line wrapping.

Please repost with my:

Acked-by: Mike Snitzer <snitzer@redhat.com>
