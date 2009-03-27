From: "Love, Robert W" <robert.w.love@intel.com>
Subject: RE: [PATCH] fcoe: prep work to completely remove fc_transport_fcoe
 code
Date: Fri, 27 Mar 2009 09:12:00 -0700
Message-ID: <273D38FBE7C6FE46A1689FCD014A0B8B3813C65D@azsmsx505.amr.corp.intel.com>
References: <20090317184151.22987.73806.stgit@fritz>
 <20090327160328.18274.31785.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:33942 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754153AbZC0QMB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Mar 2009 12:12:01 -0400
In-Reply-To: <20090327160328.18274.31785.stgit@fritz>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Love, Robert W" <robert.w.love@intel.com>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Robert Love wrote:
> From: Vasu Dev <vasu.dev@intel.com>
> 
> The fcoe transport code was added for generic FCoE transport
> infrastructure to allow additional offload related module loading
> on demand, this is not required anymore after recently added
> different offload approach by having offload related func ops
> in netdev.
> 
> This patch removes fcoe transport related code use, calls functions
> directly between existing libfcoe.c and fcoe_sw.c for now, for
> example fcoe_sw_destroy and fcoe_sw_create calling.
> 
> The fcoe_sw.c and libfcoe.c code will be further consolidated in
> later patches and then also the default fcoe sw transport code
> file fcoe_sw.c will be completely removed.
> 
> The fcoe transport code files are completely removed in next
> patch to keep this patch simple for reviewing.
> 
> --
> 
> This patch is an update to a previous patch. This update
> resolves a build error as well as fixes a defect related to
> not calling fc_release_transport().
> 
> The following updates to the other patches in the series
> are just adjustments to the changes this update introduces.
> 
> Signed-off-by: Vasu Dev <vasu.dev@intel.com>
> Signed-off-by: Robert Love <robert.w.love@intel.com>
> ---
> 
Nothing has changed since these 4 updated pathces made it to
linux-scsi two days ago. I just misspelled James' e-mail
address in when I originally sent them.
