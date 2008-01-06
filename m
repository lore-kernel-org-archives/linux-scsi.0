From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: Open-FCoE on linux-scsi
Date: Sun, 6 Jan 2008 10:28:36 +0900
Message-ID: <20080106103138Q.tomof@acm.org>
References: <10A7D0016239E24092DEF05CCC582E4302BB68C8@fmsmsx411.amr.corp.intel.com>
	<200801031035.m03AZYcJ012171@mbox.iij4u.or.jp>
	<477FCD8C.2040404@vlnb.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:59012 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752951AbYAFB2r (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 5 Jan 2008 20:28:47 -0500
In-Reply-To: <477FCD8C.2040404@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vst@vlnb.net
Cc: tomof@acm.org, robert.w.love@intel.com, yi.zou@intel.com, christopher.leech@intel.com, vasu.dev@intel.com, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jpfujita.tomonori@lab.ntt.co.jp

On Sat, 05 Jan 2008 21:33:48 +0300
Vladislav Bolkhovitin <vst@vlnb.net> wrote:

> Thus, I believe, that partial user space, partial kernel space approach 
> for building SCSI targets is the move in the wrong direction, because it 
> brings practically nothing, but costs a lot.

We have not discussed such topic. FCoE target can be implemented fully
in user space if I understand correctly.
