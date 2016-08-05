From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [dm-devel] dm-mq and end_clone_request()
Date: Fri, 5 Aug 2016 11:40:31 -0700
Message-ID: <0b4f017e-2fb2-393c-5f27-05548a497d0e@sandisk.com>
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
 <20160804235850.GB13132@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0046.outbound.protection.outlook.com ([104.47.37.46]:25967
	"EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1946726AbcHESki (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Aug 2016 14:40:38 -0400
In-Reply-To: <20160804235850.GB13132@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, Laurence Oberman <loberman@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 08/04/2016 04:58 PM, Mike Snitzer wrote:
> I've staged another fix, Laurence is seeing success with this added:
> https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-4.8&id=d50a6450104c237db1dc75314d17b78c990a8c05

Thanks Mike. I have started testing that fix this morning.

Bart.
