From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-mq and end_clone_request()
Date: Thu, 4 Aug 2016 19:58:50 -0400
Message-ID: <20160804235850.GB13132@redhat.com>
References: <20160801175948.GA6685@redhat.com>
 <f9e71e1d-54ca-40fe-a5ea-ae2863c94ff9@sandisk.com>
 <20160801204628.GA94704@redhat.com>
 <8e265fcc-8021-830e-ffcb-23a8a28ec247@sandisk.com>
 <20160802174533.GA18714@redhat.com>
 <1a460c29-1530-d3e1-25ba-736d86aff12e@sandisk.com>
 <20160803004013.GA19956@redhat.com>
 <eb1af921-d874-1f6a-c5d0-12d3cae04256@sandisk.com>
 <20160804161047.GC6989@redhat.com>
 <4d60017e-818c-5630-549e-bf280abcf1c3@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47824 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934760AbcHDX6w (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Aug 2016 19:58:52 -0400
Content-Disposition: inline
In-Reply-To: <4d60017e-818c-5630-549e-bf280abcf1c3@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, Laurence Oberman <loberman@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

I've staged another fix, Laurence is seeing success with this added:
https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-4.8&id=d50a6450104c237db1dc75314d17b78c990a8c05

I'll be sending all the fixes I've queued to Linus tonight or early
tomorrow (since I'll then be on vacation until Monday 8/15).
