From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: Open-FCoE on linux-scsi
Date: Fri, 04 Jan 2008 14:19:14 -0600
Message-ID: <477E94C2.3050106@cs.wisc.edu>
References: <10A7D0016239E24092DEF05CCC582E4302BB68C8@fmsmsx411.amr.corp.intel.com>	<200801031035.m03AZYcJ012171@mbox.iij4u.or.jp>	<10A7D0016239E24092DEF05CCC582E4302BB789B@fmsmsx411.amr.corp.intel.com> <20080104225015Z.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:46376 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752947AbYADUTd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Jan 2008 15:19:33 -0500
In-Reply-To: <20080104225015Z.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: robert.w.love@intel.com, yi.zou@intel.com, christopher.leech@intel.com, vasu.dev@intel.com, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

FUJITA Tomonori wrote:
>> Understood, but open-iscsi doesn't have the layering scheme that we do.
>> Since we're providing a Fibre Channel protocol processing layer that
>> different transport types can register with I think the generic name is
>> appropriate. Anyway, I don't think anyone here is terribly stuck on the
>> name; it's not a high priority at this time.
> 
> open-iscsi provides the proper abstraction. It can handles different
> transport types, tcp and RDMA (iSER). It supports software iSCSI
> drivers and HW iSCSI HBAs drivers. They are done via iscsi transport
> class (and libiscsi).

I think I hinted to this offlist, but the bnx2i branch in my iscsi git 
tree is best to look at for this. The upstream stuff is best the model 
where we support only HW iscsi hbas drivers (all offload) and SW iscsi 
drivers (all software). The bnx2i branch modifies the class and lib so 
it also supports a model in between the two, so pretty much everything 
is covered.
